class_name ApplyDamageOnHit
extends OnHitBehaviour

@export_group("Damage Settings")
@export var damage : float = 1.0


func on_bullet_hit(bullet : Node3D, weapon_manager: WeaponManager, incoming_body : Variant) -> void:
	var is_itself = bullet.get_instance_id() == incoming_body.get_instance_id()

	if is_itself:
		return

	if incoming_body is not HealthManager:
		if delete_bullet_on_hit:
			bullet.queue_free()
		return

	var health_manager = incoming_body as HealthManager
	var result = health_manager.take_damage(damage, weapon_manager.weapon_owner)
	if delete_bullet_on_hit and result == HealthManager.DAMAGE_SUCCESS:
		bullet.queue_free()
