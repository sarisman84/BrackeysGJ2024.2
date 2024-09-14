extends CharacterBody3D

@onready var m_nav = $navigation
@onready var m_health_manager = $health_manager
@onready var model = $model
@onready var m_weapon_manager : WeaponManager = $weapon_manager

@export var m_speed : int = 4
@export var m_shooting_distance : int = 15
var m_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var money_amount : int
@export var money_value : int

@export var blink_material : Resource

var model_meshes
var original_mat

func _ready() -> void:
	m_health_manager.health_owner = self
	m_health_manager.on_take_damage.connect(m_model_blink)
	
	model_meshes = model.find_children("*", "MeshInstance3D")
	original_mat = model_meshes[0].get_surface_override_material(0)
	
	m_weapon_manager.weapon_owner = self
	m_weapon_manager.add_weapon("machine_gun")

#func _physics_process(delta: float) -> void:
	#if !Global.player_ref:
		#return
#
	#var direction = Vector3()
#
	#m_nav.target_position = Global.player_ref.global_position
#
	#direction = m_nav.get_next_path_position() - global_position
	#direction.y = 0
	#direction = direction.normalized() * m_speed
#
	#var m_position_diff = Global.player_ref.global_position - global_position
	#if m_position_diff.length() > m_shooting_distance:
		#velocity.x = direction.x
		#velocity.z = direction.z
		#m_weapon_manager.fire_input = false
	#else:
		#velocity.x = 0
		#velocity.z = 0
		#m_weapon_manager.fire_input = true
#
	#if not is_on_floor():
		#velocity.y -= m_gravity * delta
#
	#rotation.y = - Vector2(direction.x, direction.z).angle()
	#move_and_slide()

func m_model_blink() -> void:
	for mesh in model_meshes:
		mesh.set_surface_override_material(0, blink_material)
	await get_tree().create_timer(0.5).timeout
	for mesh in model_meshes:
		mesh.set_surface_override_material(0, original_mat)

func _physics_process(delta: float) -> void:
	var m_position_diff = Global.player_ref.global_position - global_position
	m_position_diff.y = 0
	if m_position_diff.length() > m_shooting_distance:
		m_position_diff = m_position_diff.normalized() * m_speed
		velocity.x = m_position_diff.x
		velocity.z = m_position_diff.z
		m_weapon_manager.fire_input = false
	else:
		velocity.x = 0
		velocity.z = 0
		m_weapon_manager.fire_input = true

	if not is_on_floor():
		velocity.y -= m_gravity * delta
	
	rotation.y = - Vector2(m_position_diff.x, m_position_diff.z).angle()
	move_and_slide()

func _on_health_manager_on_death() -> void:
	Global.spawn_money(position, money_amount, money_value)
	queue_free()
