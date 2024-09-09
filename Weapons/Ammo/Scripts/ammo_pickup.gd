class_name AmmoPickup
extends Area3D

@export var ammo_type : String
@export var refill_amount : int = 10

func m_on_ammo_pickup(weapon_manager: WeaponManager) -> bool:
	return weapon_manager.refill_ammo_for(ItemRegistry.get_item(ammo_type).UUID, refill_amount)


func _on_body_entered(body : Variant) -> void:
	if m_on_ammo_pickup(body.weapon_manager):
		queue_free()
