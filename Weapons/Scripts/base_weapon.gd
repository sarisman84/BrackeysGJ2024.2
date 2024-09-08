extends Resource
class_name BaseWeapon

@export var fire_rate : float = 0.5
@export var clip_size : int = 10
@export_file("*.tscn") var model : String
@export var icon : Texture2D
@export var display_name : String

var m_current_clip_size : int
var m_barrel : Node3D

func _ready() -> void:
	m_current_clip_size = clip_size


func has_ammo() -> bool:
	return m_current_clip_size > 0 or clip_size < 0

func use_ammo() -> void:
	if clip_size < 0:
		return
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
