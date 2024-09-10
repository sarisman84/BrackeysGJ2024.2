class_name ApplyDamageOnHit
extends OnHitBehaviour

@export_group("Damage Settings")
@export var damage : float = 1.0


func on_bullet_hit(bullet : Node3D, weapon_manager: WeaponManager, incoming_body : Variant) -> void:
	if bullet.get_instance_id() == incoming_body.get_instance_id() or weapon_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return

	if incoming_body is not HealthManager:
		if delete_bullet_on_hit:
			bullet.queue_free()
		return

	var health_manager = incoming_body as HealthManager
	if health_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return

	health_manager.take_damage(damage)
	if delete_bullet_on_hit:
		bullet.queue_free()
