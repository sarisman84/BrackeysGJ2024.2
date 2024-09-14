class_name ApplyDamageOnHit
extends OnHitBehaviour

@export_group("Damage Settings")
@export var damage : float = 1.0


func on_bullet_hit(bullet : Node3D, weapon : BaseWeapon, weapon_manager: WeaponManager,damage_multiplier : float, incoming_body : Variant) -> void:
	var is_itself = bullet.get_instance_id() == incoming_body.get_instance_id()

	if is_itself:
		return

	var emitter := FmodEventEmitter3D.new()

	emitter.event_name = weapon.hit_sfx_name
	emitter.event_guid = weapon.hit_sfx_guid
	emitter.global_position = bullet.global_position
	emitter.preload_event = false
	emitter.play()

	weapon_manager.weapon_owner.get_tree().root.add_child(emitter)
	var timer := Timer.new()
	weapon_manager.weapon_owner.get_tree().root.add_child(timer)

	timer.start(0.5)
	timer.timeout.connect(m_clear_sfx.bind(emitter, timer))


	if incoming_body is not HealthManager:
		if delete_bullet_on_hit:
			bullet.queue_free()
		return

	var health_manager = incoming_body as HealthManager
	var result = health_manager.take_damage(damage * damage_multiplier, weapon_manager.weapon_owner)
	if delete_bullet_on_hit and result == HealthManager.DAMAGE_SUCCESS:
		bullet.queue_free()

func m_clear_sfx(emitter : FmodEventEmitter3D, timer : Timer) -> void:
	emitter.queue_free()
