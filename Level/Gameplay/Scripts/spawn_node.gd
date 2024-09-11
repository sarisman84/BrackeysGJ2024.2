class_name SpawnNode
extends Node3D


@export var spawnable_elements : Array[SpawnSetting]


var m_spawn_nodes : Array[Node3D]

func _ready() -> void:
	m_spawn_elements()

func m_spawn_elements() -> void:
	for location in get_children():
		for spawn_element in spawnable_elements:
			var chance = randf()
			if chance >= spawn_element.chance_to_spawn:
				spawn_element.spawn_object(self, location)
				break
