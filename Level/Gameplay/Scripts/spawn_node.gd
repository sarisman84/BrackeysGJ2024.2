class_name SpawnNode
extends Node3D


@export var spawnable_elements : Array[SpawnSetting]

var m_spawn_nodes : Array[Vector3]
var m_semaphore : Semaphore
var m_threads : Array[Thread]


var m_time
var m_start_point
var m_end_point

func _ready() -> void:

	m_start_point = Time.get_ticks_usec()
	get_tree().paused = true
	#Pre-load the elements to spawn
	for location in get_children():
		m_spawn_nodes.append(location.global_position)

	var element_load_thread = Thread.new()
	element_load_thread.start(func():
		for element in spawnable_elements:
			element.load_object()
		print("elements loaded!")
	)
	while element_load_thread.is_alive():
		await get_tree().physics_frame
	element_load_thread.wait_to_finish()

	#Cache all of the locations to spawn stuff on


	#Attempt to load things in a new thread.

	var thread_count =  4
	var size = m_spawn_nodes.size() / thread_count
	print("Creating %d threads with %d nodes each!" % [thread_count, size])
	var start_indx = 0
	m_semaphore = Semaphore.new()
	for i in thread_count:

		var end_indx  = i + 1
		var arr : Array = m_spawn_nodes.slice(start_indx * size, min(m_spawn_nodes.size() - 1, end_indx * size))
		var thread = Thread.new()
		var semaphore := Semaphore.new()
		thread.start(m_spawn_elements.bind(arr, m_semaphore))
		start_indx = end_indx
		m_threads.append(thread)


func _process(_delta):
	var refresh_rate = DisplayServer.screen_get_refresh_rate()
	var max_delta = 1/refresh_rate
	if _delta > max_delta:
		return
	if m_threads.all(func(t): return not t.is_alive()) and not m_threads.is_empty():
		for i in m_threads.size():
			print("freeing thread!")
			m_semaphore.post()
			m_threads[i].wait_to_finish()
		m_threads.clear()
		get_tree().paused = false
		m_end_point = Time.get_ticks_usec()
		m_time = (m_end_point - m_start_point) / 1000000.0
		print("Loading Time Elapsed: %f (Seconds)" % m_time)
	else:
		m_semaphore.post()

func m_spawn_elements(positions : Array[Vector3], semaphore : Semaphore) -> void:
	for pos in positions:
		for spawn_element in spawnable_elements:
			var chance = randf()
			if chance < spawn_element.chance_to_spawn:
				spawn_element.spawn_object_async(self, pos, semaphore)
				break
	print("batch spawned!")
