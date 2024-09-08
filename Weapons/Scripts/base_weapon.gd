extends Node3D
class_name BaseWeapon

@export var fire_rate : float = 0.5
@export var clip_size : int = 10
@export var barrel_node : Node3D

# Virtual function
func fire() -> void:
	pass
