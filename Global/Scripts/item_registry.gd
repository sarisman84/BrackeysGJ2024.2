extends Node

@export var item_registry : Array[BaseResource]
@export var spawnable_items : Array[SpawnSetting]

var m_cached_spawned_items : Dictionary

var m_loading_thread : Thread
var m_semaphore : Semaphore
var m_finished_flag : bool = false

var m_time : float
var m_start_point : float
var m_end_point : float
var m_delta : float

func _ready() -> void:
	for i in range(item_registry.size()):
		var item = item_registry[i]
		item.UUID = i
		item.init()

func get_item(item_name_or_uuid : Variant) -> Variant:
	for i in item_registry:
		match(typeof(item_name_or_uuid)):
			TYPE_STRING:
				if i.resource_path.to_lower().contains(item_name_or_uuid.to_lower()):
					return i.duplicate()
			TYPE_INT:
				if i.UUID == item_name_or_uuid:
					return i.duplicate()
	return null

func get_available_spawned_item(item_path : String, modify_process_mode : bool = true) -> Variant:
	var arr = m_cached_spawned_items[item_path]
	for i in arr.size():
		var item = arr[i]
		if not item.visible:
			item.visible = true
			if modify_process_mode:
				item.process_mode = Node.PROCESS_MODE_INHERIT
			print("[Item Registry]: %d used!" % i)
			return item
	push_error("[Item Registry]: Ran out of Available Items: %d" % arr.size())
	return null


func reset_cached_item(node : Node) -> void:
	var target_key = node.name.split("[")[0]
	for key in m_cached_spawned_items.keys():
		if key.to_lower().contains(target_key.to_lower()):
			var arr = m_cached_spawned_items[key] as Array
			var i = arr.find(node)

			arr[i].visible = false
			arr[i].process_mode = Node.PROCESS_MODE_DISABLED
			arr[i].set_position(Vector3(0, -1000, 0))
			return

func reset_all_spawned_items() -> void:
	for arr in m_cached_spawned_items.values():
		for item in arr:
			item.visible = false
			item.process_mode = Node.PROCESS_MODE_DISABLED
			item.set_position(Vector3(0, -1000, 0))


func initialize_spawn_items(thread_count : int) -> void:
	m_finished_flag = false
	m_start_point = Time.get_ticks_usec()
	m_semaphore = Semaphore.new()
	m_loading_thread = Thread.new()

	var mutex := Mutex.new()
	m_loading_thread.start(func():
		var indx = 0
		var threads : Array[Thread]
		while indx < spawnable_items.size():
			var data = spawnable_items[indx] as SpawnSetting
			var sum = data.allocated_object_count / thread_count
			var ins = ResourceLoader.load(data.object_to_spawn)
			var parent := Node.new()
			parent.name = data.object_to_spawn
			m_cached_spawned_items[ins.resource_path] = []
			print("[Item Registry]: Initializing copies of [%s]" % data.object_to_spawn)

			for i in thread_count:
				var thread := Thread.new()
				thread.start(m_spawn_items.bind(i,ins,sum, parent))
				threads.append(thread)

			while threads.any(func(t): return t.is_alive()):
				await get_tree().process_frame

			for t in threads:
				mutex.lock()
				m_cached_spawned_items[ins.resource_path].append_array(t.wait_to_finish())
				mutex.unlock()
			threads.clear()

			call_deferred("add_child", parent)

			indx += 1
		print("[Item Registry]: Spawnable Items initialized!")
		m_end_point = Time.get_ticks_usec()
		m_time = (m_end_point - m_start_point) / 1000000.0
		print("[Item Registry]: Loading Time Elapsed: %f (Seconds)" % m_time)
		mutex.lock()
		m_finished_flag = true
		mutex.unlock()
		)


func has_finished_spawning_items() -> bool:
	return m_finished_flag


func m_spawn_items(thread_id : int, item: PackedScene, sum : int, parent : Node) -> Array:
	var array : Array = []
	var refresh_rate = DisplayServer.screen_get_refresh_rate()
	for i in sum:
		var ins = item.instantiate() as Node

		ins.visible = false
		ins.name += "[t:%d|id:%d]" % [thread_id, i]
		ins.process_mode = Node.PROCESS_MODE_DISABLED
		ins.set_position(Vector3(0, -1000, 0))

		parent.call_deferred("add_child", ins)
		array.append(ins)


		if m_delta == 0 or m_delta >= (1 / refresh_rate) * 0.5:
			m_semaphore.wait()
	print("[Item Registry]: Initialized %d copies of [%s]" % [sum, item.resource_path])
	return array

func _process(_delta) -> void:
	m_delta = _delta
	if not has_finished_spawning_items() and m_semaphore:
		m_semaphore.post()
	if m_finished_flag and m_loading_thread.is_alive():
		m_loading_thread.wait_to_finish()
