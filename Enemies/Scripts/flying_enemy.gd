extends CharacterBody3D

@export var m_speed : int = 4

@export var money_amount : int
@export var money_value : int
@export var blink_material : Resource

@onready var m_health_manager = $health_manager
@onready var model = $model

var model_meshes
var original_mat

func _ready() -> void:
	m_health_manager.health_owner = self
	m_health_manager.on_take_damage.connect(m_model_blink)

	model_meshes = model.find_children("*", "MeshInstance3D")
	original_mat = model_meshes[0].get_surface_override_material(0)

func _physics_process(_delta: float) -> void:
	if !Global.player_ref:
		return

	var m_position_diff = Global.player_ref.global_position - global_position
	m_position_diff = m_position_diff.normalized() * m_speed
	velocity = m_position_diff

	rotation.y = - Vector2(m_position_diff.x, m_position_diff.z).angle()
	move_and_slide()

func m_model_blink() -> void:
	for mesh in model_meshes:
		mesh.set_surface_override_material(0, blink_material)
	await get_tree().create_timer(0.5).timeout
	for mesh in model_meshes:
		mesh.set_surface_override_material(0, original_mat)

func _on_health_manager_on_death() -> void:
	Global.spawn_money(position, money_amount, money_value)
	queue_free()
