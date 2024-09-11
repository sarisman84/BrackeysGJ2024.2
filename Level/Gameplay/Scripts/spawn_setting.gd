class_name SpawnSetting
extends Resource

@export_file("*.tscn") var object_to_spawn : String
@export_range(0.0,1.0) var chance_to_spawn : float = 1.0
@export var min_objects_to_spawn : int = 1
@export var max_objects_to_spawn : int = 1
@export var object_placement_area_size : Vector3i = Vector3i.ONE


func spawn_object(owner : Node3D, location :Node3D) -> int:
	const EXIT := 0


	assert(not object_to_spawn.is_empty(), "[%s] Object to Spawn path is empty!" % resource_name)
	assert(min_objects_to_spawn > 0, "[%s] Spawn Amount must be atleast a minimum of 1" % resource_name)
	assert(max_objects_to_spawn >= min_objects_to_spawn, "[%s] Maximum Spawn Amount must be atleast equal of greater than the minimum amount!" % resource_name)
	assert(object_placement_area_size.length() > 0, "[%s] Spawn Area must be atleast 1x1x1" % resource_name)

	var spawn_pos = location.global_position
	var spawn_amm = randi_range(min_objects_to_spawn, max_objects_to_spawn)

	var half_extends = object_placement_area_size / 2
	var spawn_counter : int = 0

	for y in object_placement_area_size.y:
		for z in object_placement_area_size.z:
			for x in object_placement_area_size.x:
				var pos = spawn_pos + Vector3(x - half_extends.x, y - half_extends.y, z - half_extends.z)
				var obj := m_spawn_object(owner,object_to_spawn)
				obj.global_position = pos
				spawn_counter += 1
				if spawn_counter >= spawn_amm:
					return EXIT
	return EXIT


func m_spawn_object(owner : Node3D, object_to_spawn : String) -> Node3D:
	var scene : PackedScene = ResourceLoader.load(object_to_spawn)
	var ins := scene.instantiate() as Node3D
	owner.add_child(ins)
	return ins
