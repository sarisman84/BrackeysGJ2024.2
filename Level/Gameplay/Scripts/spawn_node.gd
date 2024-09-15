class_name SpawnNode
extends Node3D


@export var spawnable_elements : Array[SpawnSetting]

var m_spawn_nodes : Array[Vector3]


func _ready() -> void:
	for child in get_children():
		for i in spawnable_elements.size():

			var chance = randf()
			var data = spawnable_elements[i]

			if chance < data.chance_to_spawn:
				spawnable_elements[i].spawn_object(child.global_position)
				break
