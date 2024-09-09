extends RigidBody3D

var m_direction : Vector3
var m_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
func _ready() -> void:
	pass

func init() -> void:
	m_direction = global_basis.z
	linear_velocity = m_direction

func _physics_process(_delta : float) -> void:
	linear_velocity.y -= m_gravity * _delta

func _on_hurtbox_body_entered(_body : Variant) -> void:
	queue_free()
