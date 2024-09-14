class_name SpawnSetting
extends BaseResource

@export_file("*.tscn") var object_to_spawn : String
@export var allocated_object_count : int = 100
@export_range(0.0,1.0) var chance_to_spawn : float = 1.0
@export var min_objects_to_spawn : int = 1
@export var max_objects_to_spawn : int = 1
@export var object_placement_area_size : Vector3i = Vector3i.ONE

const SPAWN_OK = 0
const SPAWN_ERR = -1


func spawn_object(location : Vector3) -> int:
	assert(not object_to_spawn.is_empty(), "[Spawn Setting - %s] Object to Spawn path is empty!" % resource_name)
	assert(min_objects_to_spawn > 0, "[Spawn Setting - %s] Spawn Amount must be atleast a minimum of 1" % resource_name)
	assert(max_objects_to_spawn >= min_objects_to_spawn, "[Spawn Setting - %s] Maximum Spawn Amount must be atleast equal of greater than the minimum amount!" % resource_name)
	assert(object_placement_area_size.length() > 0, "[Spawn Setting - %s] Spawn Area must be atleast 1x1x1" % resource_name)


	var spawn_pos = location
	var spawn_amm = randi_range(min_objects_to_spawn, max_objects_to_spawn)

	if object_placement_area_size.length() < 2:
		for i in spawn_amm:
			var ins = ItemRegistry.get_available_spawned_item(object_to_spawn, false) as Node3D
			ins.global_position = spawn_pos
			ins.process_mode = Node.PROCESS_MODE_INHERIT
		return SPAWN_OK

	var half_extends = object_placement_area_size / 2
	var spawn_counter : int = 0

	for y in object_placement_area_size.y:
		for z in object_placement_area_size.z:
			for x in object_placement_area_size.x:
				var pos = spawn_pos + Vector3(x - half_extends.x, y - half_extends.y, z - half_extends.z)
				var ins = ItemRegistry.get_available_spawned_item(object_to_spawn, false) as Node3D
				ins.global_position = pos
				ins.process_mode = Node.PROCESS_MODE_INHERIT
				spawn_counter += 1
				if spawn_counter >= spawn_amm:
					return SPAWN_OK

	return SPAWN_ERR
