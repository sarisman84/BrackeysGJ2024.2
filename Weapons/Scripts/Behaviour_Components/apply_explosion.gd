class_name ApplyExplosionOnHit
extends OnHitBehaviour

@export_group("Explosion Settings")
@export var damage : int
@export var explosion_shape : Shape3D
@export_flags_3d_physics var explosion_detection_mask : int
@export var explosion_detection_duration_in_seconds : float

func on_bullet_hit(bullet : Node3D, weapon_manager: WeaponManager, incoming_body : Variant) -> void:
	if bullet.get_instance_id() == incoming_body.get_instance_id() or weapon_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return

	var hit_pos = bullet.global_position
	if delete_bullet_on_hit:
		bullet.queue_free()

	var explosion_hitbox = Area3D.new()
	var col = CollisionShape3D.new()
	col.shape = explosion_shape

	explosion_hitbox.collision_mask = explosion_detection_mask
	explosion_hitbox.add_child(col)
	explosion_hitbox.body_entered.connect(func(incoming_body : Variant): on_explosion(weapon_manager, incoming_body))

	var scene_tree = weapon_manager.get_tree()
	scene_tree.root.add_child(explosion_hitbox)

	explosion_hitbox.global_position = hit_pos

	var timer = Timer.new()
	scene_tree.root.add_child(timer)
	timer.start(explosion_detection_duration_in_seconds)
	timer.timeout.connect(on_explosion_expire.bind(explosion_hitbox))

func on_explosion(weapon_manager: WeaponManager, incoming_body : Variant) -> void:
	if weapon_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return
	var health_manager = incoming_body as HealthManager
	if health_manager.owner.get_instance_id() == incoming_body.get_instance_id():
		return

	health_manager.take_damage(damage)

func on_explosion_expire(explosion_hitbox : Area3D) -> void:
	explosion_hitbox.queue_free()
