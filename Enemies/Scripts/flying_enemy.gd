extends CharacterBody3D

@export var m_speed : int = 6

func _physics_process(_delta: float) -> void:
	var m_position_diff = Global.player_ref.global_position - global_position
	m_position_diff = m_position_diff.normalized() * m_speed
	velocity = m_position_diff

	move_and_slide()
