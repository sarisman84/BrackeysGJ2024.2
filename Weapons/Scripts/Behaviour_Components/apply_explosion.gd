class_name ApplyExplosionOnHit
extends OnHitBehaviour

@export_group("Explosion Settings")
@export var damage : int
@export var explosion_shape : Shape3D
@export_flags_3d_physics var explosion_detection_mask : int
@export var explosion_detection_duration_in_seconds : float
@export var explosion_vfx : PackedScene

func on_bullet_hit(bullet : Node3D, weapon : BaseWeapon, weapon_manager: WeaponManager,damage_multiplier : float, incoming_body : Variant) -> void:
	var is_itself = bullet.get_instance_id() == incoming_body.get_instance_id()

	if is_itself :
		return
        
	if incoming_body.get_parent().get_instance_id() == weapon_manager.weapon_owner.get_instance_id():
		return
	
	var emitter := FmodEventEmitter3D.new()

	emitter.event_name = weapon.hit_sfx_name
	emitter.event_guid = weapon.hit_sfx_guid
	emitter.global_position = bullet.global_position
	emitter.preload_event = false
	emitter.play()

	var timer := Timer.new()
	timer.start(0.5)
	timer.timeout.connect(m_clear_sfx.bind(emitter))

	print("[ApplyExplosionOnHit]: collison: %s" % incoming_body.name)

	var hit_pos = bullet.global_position
	if delete_bullet_on_hit:
		bullet.queue_free()

	var explosion_hitbox = Area3D.new()
	var col = CollisionShape3D.new()
	col.shape = explosion_shape

	explosion_hitbox.collision_mask = explosion_detection_mask
	explosion_hitbox.add_child(col)
	explosion_hitbox.body_entered.connect(func(incoming_body : Variant): on_explosion(damage_multiplier, weapon_manager, incoming_body))
	explosion_hitbox.area_entered.connect(func(incoming_body : Variant): on_explosion(damage_multiplier, weapon_manager, incoming_body))

	var scene_tree = weapon_manager.get_tree()
	scene_tree.root.add_child(explosion_hitbox)
	
	explosion_hitbox.global_position = hit_pos

	timer = Timer.new()
	scene_tree.root.add_child(timer)
	timer.start(explosion_detection_duration_in_seconds)
	timer.timeout.connect(on_explosion_expire.bind(explosion_hitbox, timer))
	
	var vfx = explosion_vfx.instantiate()
	vfx.global_position = hit_pos
	vfx.scale = Vector3(4, 4, 4)
	scene_tree.root.add_child(vfx)

func m_clear_sfx(emitter : FmodEventEmitter3D) -> void:
	emitter.queue_free()

func on_explosion(damage_multiplier : float,weapon_manager: WeaponManager, incoming_body : Variant) -> void:
	if weapon_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return
	var health_manager = incoming_body as HealthManager
	if health_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return

	health_manager.take_damage(damage * damage_multiplier, weapon_manager.weapon_owner)

func on_explosion_expire(explosion_hitbox : Area3D, timer : Timer) -> void:
	explosion_hitbox.queue_free()
	timer.queue_free()
