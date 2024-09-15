extends Node3D

@export var mouse_sensitivity : float = 0.001

@onready var pitch_pivot = $pitch_pivot
@onready var weapon_manager = %weapon_manager

var m_mouse_delta : Vector2

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass

func _process(_delta : float) -> void:
	#Rotate the camera based on mouse delta

	#Left-Right rotation
	rotate_y(m_mouse_delta.x)

	#Up-Down rotation with clamps to limit where the player can look.
	#TODO: Expose the limits to better customize the camera
	pitch_pivot.rotate_x(m_mouse_delta.y)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, -0.5, 0.5)

	#Rotate player weapon with the camera
	#TODO: Maybe move this somewhere else
	var model_col = weapon_manager.m_internal_weapon_models
	if not model_col.is_empty():
		model_col[weapon_manager.selected_weapon].rotate_x(m_mouse_delta.y)
		model_col[weapon_manager.selected_weapon].rotation.x = clamp(model_col[weapon_manager.selected_weapon].rotation.x, -0.5, 0.5)

	m_mouse_delta = Vector2.ZERO

func _unhandled_input(event : InputEvent) -> void:
	if event is not InputEventMouseMotion or Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	m_mouse_delta = -event.relative * mouse_sensitivity
