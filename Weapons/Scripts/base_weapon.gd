extends Node3D
class_name BaseWeapon

@export var fire_rate : float = 0.5
@export var clip_size : int = 10
@export var barrel_node : Node3D

var m_current_clip_size : int

func _ready() -> void:
	m_current_clip_size = clip_size

func has_ammo() -> bool:
	return m_current_clip_size > 0

func use_ammo() -> void:
	m_current_clip_size -= 1

func refill_ammo(amount: int) -> bool:
	if m_current_clip_size >= clip_size:
		return false

	m_current_clip_size += amount
	m_current_clip_size = max(m_current_clip_size, clip_size)
	return true


# Virtual function
func fire() -> void:
	pass
