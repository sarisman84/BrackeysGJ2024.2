class_name HealthManager
extends StaticBody3D


@export var max_health : int
var m_current_health : int

signal on_take_damage
signal on_heal
signal on_death

func reset_health() -> void:
	m_current_health = max_health

func heal(amount : int) -> bool:
	if m_current_health >= max_health:
		return false

	m_current_health += amount
	m_current_health = max(m_current_health, max_health)

	on_heal.emit()
	return true

func take_damage(amount : int) -> void:
	m_current_health -= amount
	m_current_health = max(m_current_health, 0)
	if m_current_health == 0:
		on_death.emit()
	else:
		on_take_damage.emit()
