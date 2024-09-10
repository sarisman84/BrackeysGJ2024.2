extends CharacterBody3D

@export var m_speed : int = 4
var m_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var money_amount : int
@export var money_value : int 

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	_on_health_manager_on_death()

func _physics_process(delta: float) -> void:
	var m_position_diff = Global.player_coords - position 
	m_position_diff.y = 0
	m_position_diff = m_position_diff.normalized() * m_speed
	velocity.x = m_position_diff.x
	velocity.z = m_position_diff.z
	
	if not is_on_floor():
		velocity.y -= m_gravity * delta
	
	move_and_slide()

func _on_health_manager_on_death() -> void:
	Global.spawn_money(position, money_amount, money_value)
	queue_free()
