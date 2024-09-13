class_name AvatarController
extends CharacterBody3D


@export_group("Movement Settings")
@export var movement_speed : float
@export var ground_acceleration : float = 25
@export var ground_decceleration : float = 25
@export var air_acceleration : float = 5
@export var air_decceleration : float = 5
@export_group("Jump Settings")
@export var jump_height : float = 1.0
@export var jump_count : int = 1

@onready var camera = %camera
@onready var model = $model
@onready var weapon_manager = %weapon_manager
@onready var weapon_select = $weapon_select
@onready var shop = $shop
#@onready var interaction_manager = %interaction_manager
@onready var main_ui = $main_ui
@onready var health_manager = $health_manager
@onready var game_over = $game_over

var shop_open = false

var m_jump_count : int = 0
var m_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready() -> void:
	health_manager.health_owner = self
	weapon_manager.weapon_owner = self
	Global.player_ref = self

	health_manager.on_death.connect(m_on_death)

	weapon_select.init(weapon_manager)
	shop.init(weapon_manager)
	main_ui.init(health_manager, weapon_manager)


	main_ui.m_update_visual_max_health(health_manager)
	main_ui.m_update_visual_health_bar(health_manager)
	#DEBUG
	Global.current_currency = 100000

func _physics_process(delta : float) -> void:
	if shop_open:
		return

	if not is_on_floor():
		velocity.y -= m_gravity * delta

	var acceleration = ground_acceleration
	var decceleration = ground_decceleration

	if not is_on_floor():
		acceleration = air_acceleration
		decceleration = air_decceleration

	if is_on_floor():
		m_jump_count = jump_count

	if Input.is_action_pressed("jump") and m_jump_count > 0:
		velocity.y = m_calculate_jump_velocity()
		m_jump_count -= 1
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
	#Global.player_coords = position


func _process(_delta : float) -> void:
	var cam_dir = camera.global_basis.z
	model.rotation.y = atan2(cam_dir.x, cam_dir.z)
	#const ROTATION_SMOOTHING := 25
	#model.rotation.y = lerp(model.rotation.y, atan2(cam_dir.x, cam_dir.z), ROTATION_SMOOTHING * delta)

	#Handle Weapon Fire
	weapon_manager.fire_input = Input.is_action_pressed("weapon_fire")

func m_calculate_input_direction() -> Vector3:
	var local_dir = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_forward", "move_backward"))
	var result = camera.global_basis.x * local_dir.x + camera.global_basis.z * local_dir.z
	result.y = 0
	return result

func m_calculate_jump_velocity() -> float:
	return sqrt(2 * jump_height / m_gravity) * m_gravity

func m_on_death() -> void:
	game_over.transition(self)
	pass
#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("interact") and Global.player_at_shop:
		#if shop_open:
			#shop.hide_shop()
			#shop_open = false
		#else:
			#shop.show_shop()
			#shop_open = true
