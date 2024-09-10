extends CharacterBody3D

@export var m_speed : int = 4

@export var money_amount : int
@export var money_value : int 

func _physics_process(_delta: float) -> void:
	var m_position_diff = Global.player_coords - position 
	m_position_diff = m_position_diff.normalized() * m_speed
	velocity = m_position_diff
	
	move_and_slide()

func _on_health_manager_on_death() -> void:
	Global.spawn_money(position, money_amount, money_value)
	queue_free()
