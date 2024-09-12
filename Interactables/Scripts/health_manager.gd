class_name HealthManager
extends Node3D

@export var max_health : int
var m_current_health : int
var health_owner : Node3D

signal on_take_damage
signal on_heal
signal on_death

const DAMAGE_INVALID_ORIGINATOR = -1
const DAMAGE_SUCCESS = 0

func _ready() -> void:
	reset_health()

func reset_health() -> void:
	m_current_health = max_health

func heal(amount : int) -> bool:
	if m_current_health >= max_health:
		return false

	m_current_health += amount
	m_current_health = max(m_current_health, max_health)

	on_heal.emit()
	return true

func take_damage(amount : int, originator : Node3D = null) -> int:
	if originator and health_owner.get_instance_id() == originator.get_instance_id():
		print("[Health Manager]: %s is attempting to hit itself!" % originator.name)
		return DAMAGE_INVALID_ORIGINATOR

	m_current_health -= amount
	m_current_health = max(m_current_health, 0)
	if m_current_health == 0:
		on_death.emit()
	else:
		on_take_damage.emit()

	return DAMAGE_SUCCESS
