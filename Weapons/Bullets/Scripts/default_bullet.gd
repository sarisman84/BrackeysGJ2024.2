extends Node3D

var m_direction : Vector3
@export var lifetime : float

var m_internal_clock : float = 3.0

func _ready() -> void:
	m_internal_clock = lifetime

func init() -> void:
	m_direction = global_basis.z

func _process(_delta : float) -> void:
	m_internal_clock -= _delta
	if m_internal_clock <= 0:
		queue_free()
		return
	position += m_direction

func _on_hurtbox_body_entered(body : Variant) -> void:
	queue_free()
