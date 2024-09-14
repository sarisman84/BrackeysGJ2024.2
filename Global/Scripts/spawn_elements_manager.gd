extends Node

@export var elements_to_spawn : Array[SpawnSetting]
@export var element_count_per_type : int = 1000
@export var thread_amount : int = 4

var cached_elements : Dictionary

var m_threads : Array[Thread]
var m_instances : Array
var m_parents_of_elements : Array
var m_mutex : Mutex
var m_semaphore : Semaphore

var m_time : float
var m_start_point : float
var m_end_point : float

func _ready() -> void:
	m_start_point = Time.get_ticks_usec()

	m_mutex = Mutex.new()
	m_semaphore = Semaphore.new()
	var load_thread := Thread.new()
	print("Loading elements!")
	var callable = func():
		for element in elements_to_spawn:
			var ins = ResourceLoader.load(element.object_to_spawn)
			m_instances.append(ins)
			var parent = Node.new()
			parent.name = ins.resource_path
			m_parents_of_elements.append(parent)
			var arr : Array = []
			cached_elements[ins.resource_path] = arr

			print("Element [%s] loaded!" % ins.resource_path)
			#m_semaphore.wait()

	load_thread.start(callable)
	while load_thread.is_alive():
		await get_tree().process_frame
	load_thread.wait_to_finish()

	print("All elements loaded!")

	print("Creating Instances!")
	for i in thread_amount:
		var thread := Thread.new()
		var amm = element_count_per_type / thread_amount
		thread.start(m_spawn_cached_elements.bind(i,amm))
		m_threads.append(thread)
		#print("Utilizing thread %d to create instances of %d" % [i, amm])


func get_element(resource_path : String) -> Variant:
	var arr = cached_elements[resource_path] as Array
	for i in arr:
		if not i.visible:
			i.visible = true
			i.process_mode = Node.PROCESS_MODE_INHERIT
			return i
	return null

func _process(_delta) -> void:
	if m_threads.is_empty():
		return

	if m_threads.all(func(t): return not t.is_alive()):
		for thread in m_threads:
			m_semaphore.post()
			thread.wait_to_finish()
		m_threads.clear()
		m_end_point = Time.get_ticks_usec()
		m_time = (m_end_point - m_start_point) / 1000000.0
		print("Loading Complete! Time taken: %f seconds" % m_time)
		for parent in m_parents_of_elements:
			add_child(parent)
	else:
		m_semaphore.post()

func m_spawn_cached_elements(thread_id :int, elements_to_generate : int) -> void:
		var obj_count = 0
		var data : Dictionary
		for i in m_instances.size():
			var parent = m_parents_of_elements[i] as Node
			var ins = m_instances[i] as PackedScene
			var arr : Array = []
			data[ins.resource_path] = arr
			for e in elements_to_generate:
				var node = ins.instantiate()
				node.visible = false
				node.process_mode = Node.PROCESS_MODE_DISABLED
				node.name += "[%d:%d]" % [thread_id, e]
				parent.add_child(node)
				data[ins.resource_path].append(node)
				obj_count += 1

				if obj_count > 65:
					#print("Max Objects to create per tick reached, waiting!")
					m_semaphore.wait()
					obj_count = 0
			#print("Instanced %d objects of %s" % [elements_to_generate, ins.resource_path])
		m_mutex.lock()
		cached_elements.merge(data)
		m_mutex.unlock()
