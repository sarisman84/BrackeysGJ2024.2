extends Node3D

var m_owner : Node3D
var m_direction : Vector3
@export var lifetime : float = 3.0

var m_internal_clock : float = 3.0

func _ready() -> void:
	m_internal_clock = lifetime

func init(owner : Node3D) -> void:
	m_direction = global_basis.z
	m_owner = owner

func _process(_delta : float) -> void:
	m_internal_clock -= _delta
	if m_internal_clock <= 0:
		queue_free()
		return
	position += m_direction

func _on_hurtbox_body_entered(_body : Variant) -> void:
	if m_owner.get_instance_id() == _body.get_instance_id():
		return
	queue_free()
