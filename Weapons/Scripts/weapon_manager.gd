class_name WeaponManager
extends Node3D

var m_internal_clock : float
var m_weapon_inventory : Dictionary
var m_internal_weapon_models : Dictionary

var fire_input : bool
var selected_weapon : String :
	set(value):
		m_set_all_weapon_visibility(false)
		selected_weapon = value
		m_internal_clock = 0
		m_internal_weapon_models[value].visible = true


func refill_ammo_for(weapon_type : String, refill_amount : int) -> bool:
	return m_weapon_inventory[weapon_type].refill_ammo(refill_amount)

func add_weapon(new_weapon: String) -> void:
	var weapon = ItemRegistry.get_item(new_weapon) as BaseWeapon
	assert(weapon)
	weapon.refill_ammo(weapon.clip_size)
	m_internal_weapon_models[new_weapon] = weapon.instantiate_weapon_model(self)
	m_weapon_inventory[new_weapon] = weapon
	selected_weapon = new_weapon


func m_set_all_weapon_visibility(new_visibility : bool) -> void:
	for model in m_internal_weapon_models:
		m_internal_weapon_models[model].visible = new_visibility

#func add_weapon(new_weapon: PackedScene) -> void:
	#var weapon = new_weapon.instantiate() as BaseWeapon
	#assert(weapon)
	#add_child(weapon)
#
	#var last_indx = m_weapon_inventory.size() - 1
	#m_weapon_inventory.append(weapon)
	#selected_weapon_index = last_indx


func _ready() -> void:
	add_weapon("machine_gun")
	pass

func _process(_delta : float) -> void:
	m_internal_clock -= _delta
	m_internal_clock = max(m_internal_clock, 0)
	assert(not m_weapon_inventory.is_empty())
	var weapon = m_weapon_inventory[selected_weapon]

	if m_internal_clock == 0 and fire_input and weapon.has_ammo():
		weapon.fire(self)
		weapon.use_ammo()
		m_internal_clock = weapon.fire_rate
