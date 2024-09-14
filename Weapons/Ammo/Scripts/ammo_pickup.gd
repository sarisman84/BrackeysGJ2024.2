class_name AmmoPickup
extends Area3D

@export var ammo_type : String
@export var refill_amount_ratio : float = 0.3


func m_on_ammo_pickup(weapon_manager: WeaponManager) -> bool:
	var weapon_inventory = weapon_manager.m_weapon_inventory
	var selected_weapon = weapon_inventory[weapon_manager.selected_weapon]
	if selected_weapon.m_current_clip_size != selected_weapon.clip_size:
		return weapon_manager.refill_ammo_for(selected_weapon.UUID, selected_weapon.clip_size * refill_amount_ratio)
	else:
		var index : int = 0
		var ratio : float = 1.0
		for i in weapon_inventory.size():
			var weapon = weapon_inventory[i]
			if weapon.m_current_clip_size / weapon.clip_size < ratio:
				index = i
				ratio = weapon.m_current_clip_size / weapon.clip_size
		return weapon_manager.refill_ammo_for(weapon_inventory[index].UUID, weapon_inventory[index].clip_size * refill_amount_ratio)



# weapon_manager.refill_ammo_for(ItemRegistry.get_item(ammo_type).UUID, refill_amount)


func _on_body_entered(body : Variant) -> void:
	if body is not AvatarController:
		return
	if m_on_ammo_pickup(body.weapon_manager):
		queue_free()
