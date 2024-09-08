extends CharacterBody3D


@export_group("Movement Settings")
@export var movement_speed : float
@export var ground_acceleration : float = 25
@export var ground_decceleration : float = 25
@export var air_acceleration : float = 5
@export var air_decceleration : float = 5
@export_group("Jump Settings")
@export var jump_height : float = 1.0

@onready var camera = %camera
@onready var model = $model
@onready var weapon_manager = %weapon_manager


var m_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta : float) -> void:

	if not is_on_floor():
		velocity.y -= m_gravity * delta

	var acceleration = ground_acceleration
	var decceleration = ground_decceleration

	if not is_on_floor():
		acceleration = air_acceleration
		decceleration = air_decceleration

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = m_calculate_jump_velocity()
	else:
		var dir = m_calculate_input_direction()

		if dir.length() > 0:
			var speed = movement_speed
			#if Input.is_action_pressed("sprint"):
				#speed = sprint_speed

			var y_vel = velocity.y
			velocity = lerp(velocity, dir * speed, acceleration * delta)
			velocity.y = y_vel
		else:
			var y_vel = velocity.y
			velocity = lerp(velocity, Vector3.ZERO, decceleration * delta)
			velocity.y = y_vel


	move_and_slide()


func _process(delta : float) -> void:
	var cam_dir = camera.global_basis.z
	const ROTATION_SMOOTHING := 25
	model.rotation.y = lerp(model.rotation.y, atan2(cam_dir.x, cam_dir.z), ROTATION_SMOOTHING * delta)

	weapon_manager.fire_input = Input.is_action_pressed("weapon_fire")

func m_calculate_input_direction() -> Vector3:
	var local_dir = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_forward", "move_backward"))
	var result = camera.global_basis.x * local_dir.x + camera.global_basis.z * local_dir.z
	result.y = 0
	return result


func m_calculate_jump_velocity() -> float:
	return sqrt(2 * jump_height / m_gravity) * m_gravity
