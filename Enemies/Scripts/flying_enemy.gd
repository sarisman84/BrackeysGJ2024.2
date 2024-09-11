extends CharacterBody3D

@export var m_speed : int = 4

@export var money_amount : int
@export var money_value : int 

func _physics_process(_delta: float) -> void:
	if !Global.player_ref:
		return
	
	var m_position_diff = Global.player_ref.global_position - global_position
	m_position_diff = m_position_diff.normalized() * m_speed
	velocity = m_position_diff
	
	rotation.y = - Vector2(m_position_diff.x, m_position_diff.z).angle()
	move_and_slide()

func _on_health_manager_on_death() -> void:
	Global.spawn_money(position, money_amount, money_value)
	queue_free()
