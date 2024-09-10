class_name WeaponManager
extends Node3D

var m_internal_clock : float
var m_weapon_inventory : Array[BaseWeapon]
var m_internal_weapon_models : Array[Node3D]

signal on_weapon_switch
signal on_weapon_fire
signal on_weapon_refill

var fire_input_override : bool
var fire_input : bool
var player : AvatarController

var selected_weapon : int :
	set(value):
		m_set_all_weapon_visibility(false)
		selected_weapon = value
		m_internal_clock = 0
		m_internal_weapon_models[value].visible = true
		on_weapon_switch.emit()


func refill_ammo_for(weapon_name_or_uuid : Variant, refill_amount : int) -> bool:
	for i in range(m_weapon_inventory.size()):
		var w = m_weapon_inventory[i]

		match typeof(weapon_name_or_uuid):
			TYPE_STRING:
				if w.resource_path.to_lower().contains(weapon_name_or_uuid.to_lower()):
					var result = w.refill_ammo(refill_amount)
					if result:
						on_weapon_refill.emit()
					return result
			TYPE_INT:
				if w.UUID == weapon_name_or_uuid:
					var result = w.refill_ammo(refill_amount)
					if result:
						on_weapon_refill.emit()
					return result



	return false

func add_weapon(new_weapon: Variant) -> void:
	var weapon = ItemRegistry.get_item(new_weapon) as BaseWeapon
	assert(weapon)
	weapon.refill_ammo(weapon.clip_size)

	var last_indx = m_weapon_inventory.size()

	m_internal_weapon_models.append(weapon.instantiate_weapon_model(self))
	m_weapon_inventory.append(weapon)
	selected_weapon = last_indx

func get_weapon(weapon_name_or_uuid: Variant) -> BaseWeapon:
	for i in range(m_weapon_inventory.size()):
		var w = m_weapon_inventory[i]
		match typeof(weapon_name_or_uuid):
			TYPE_STRING:
				if w.resource_path.to_lower().contains(weapon_name_or_uuid.to_lower()):
					return w
			TYPE_INT:
				if w.UUID == weapon_name_or_uuid:
					return w
	return null

func m_set_all_weapon_visibility(new_visibility : bool) -> void:
	for model in m_internal_weapon_models:
		model.visible = new_visibility

#func add_weapon(new_weapon: PackedScene) -> void:
	#var weapon = new_weapon.instantiate() as BaseWeapon
	#assert(weapon)
	#add_child(weapon)
#
	#var last_indx = m_weapon_inventory.size() - 1
	#m_weapon_inventory.append(weapon)
	#selected_weapon_index = last_indx


func _ready() -> void:
	#WeaponBehaviours.init()
	add_weapon("machine_gun")
	pass

func _process(_delta : float) -> void:
	m_internal_clock -= _delta
	m_internal_clock = max(m_internal_clock, 0)
	assert(not m_weapon_inventory.is_empty())
	var weapon = m_weapon_inventory[selected_weapon]

	if not fire_input_override and m_internal_clock == 0 and fire_input and weapon.has_ammo():
		weapon.fire(self)
		weapon.use_ammo()
		m_internal_clock = weapon.fire_rate
		on_weapon_fire.emit()
