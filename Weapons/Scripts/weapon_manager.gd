extends Node3D

var m_weapon_inventory : Array[BaseWeapon]

var m_internal_clock : float

var selected_weapon : BaseWeapon :
	get():
		if m_weapon_inventory.is_empty():
			return null
		return m_weapon_inventory[selected_weapon_index]

var fire_input : bool
var selected_weapon_index : int :
	set(value):
		m_weapon_inventory[selected_weapon_index].visible = false
		selected_weapon_index = value
		m_internal_clock = 0
		m_weapon_inventory[selected_weapon_index].visible = true

func _ready() -> void:
	for child in get_children():
		if child is BaseWeapon:
			m_weapon_inventory.append(child)
			child.visible = false
	selected_weapon_index = 0

func _process(_delta : float) -> void:
	m_internal_clock -= _delta
	m_internal_clock = max(m_internal_clock, 0)

	if m_internal_clock == 0 and fire_input:
		assert(not m_weapon_inventory.is_empty())
		var weapon = m_weapon_inventory[selected_weapon_index]
		weapon.fire()
		m_internal_clock = weapon.fire_rate
