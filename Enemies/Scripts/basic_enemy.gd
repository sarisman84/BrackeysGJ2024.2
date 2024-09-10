extends CharacterBody3D

@export var m_speed : int = 10
var m_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	var m_position_diff = Global.player_ref.global_position - global_position
	m_position_diff.y = 0
	m_position_diff = m_position_diff.normalized() * m_speed
	velocity.x = m_position_diff.x
	velocity.z = m_position_diff.z

	if not is_on_floor():
		velocity.y -= m_gravity * delta

	move_and_slide()
