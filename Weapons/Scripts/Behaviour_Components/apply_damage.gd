class_name ApplyDamageOnHit
extends OnHitBehaviour

@export_group("Damage Settings")
@export var damage : float = 1.0


func on_bullet_hit(bullet : Node3D, weapon_manager: WeaponManager, incoming_body : Variant) -> void:
	var is_itself = bullet.get_instance_id() == incoming_body.get_instance_id()
	var is_owner = weapon_manager.owner.get_instance_id() == incoming_body.get_instance_id()


	if is_itself or is_owner:
		return

	if incoming_body is not HealthManager:
		if delete_bullet_on_hit:
			bullet.queue_free()
		return

	var health_manager = incoming_body as HealthManager
	var is_owner_hitbox = health_manager.owner.get_instance_id() == incoming_body.get_instance_id()
	if is_owner_hitbox:
		return

	health_manager.take_damage(damage)
	if delete_bullet_on_hit:
		bullet.queue_free()
