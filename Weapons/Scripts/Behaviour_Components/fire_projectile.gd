class_name FireProjectile
extends BaseBehaviour

@export_group("Fire Projectile Settings")
@export_file("*tscn") var bullet_ins : String
@export var bullet_amount : int = 1
@export var delay_between_bullets_shot_in_seconds : float = 0.0
@export var bullet_spread_in_degrees : float = 0.0
@export var bullet_direction_offset : Vector3 = Vector3.ZERO
@export var bullet_velocity : float = 100
@export var bullet_gravity : float = 0
@export var bullet_collision_shape : Shape3D

func m_create_projectile(owner : WeaponManager) -> RigidBody3D:
	var proj := RigidBody3D.new()
	var hitbox = CollisionShape3D.new()
	hitbox.shape = bullet_collision_shape
	proj.gravity_scale = bullet_gravity
	proj.add_child(hitbox)
	owner.weapon_owner.get_parent().add_child(proj)
	return proj

func apply_behaviour(args : Dictionary = {}) -> Dictionary:

	assert(args.has("weapon"))
	assert(args.has("owner"))

	var weapon : BaseWeapon = args["weapon"]
	var owner : WeaponManager = args["owner"]

	var scene_tree = owner.get_tree()

	var bullets : Array
	for i in bullet_amount:
		var bullet := m_create_projectile(owner)
		bullet.add_child(weapon.instantiate_scene(bullet_ins))
		if delay_between_bullets_shot_in_seconds > 0:
			await scene_tree.create_timer(delay_between_bullets_shot_in_seconds).timeout

		var matrix = weapon.get_barrel().global_basis

		var dir = (-matrix.z + bullet_direction_offset).normalized()

		var deg =  (bullet_spread_in_degrees / 2.0)
		if deg > 0.0:
			dir = dir.rotated(matrix.x, deg_to_rad(randf_range(-deg, deg)))
			dir = dir.rotated(matrix.y, deg_to_rad(randf_range(-deg, deg)))
			dir = dir.rotated(matrix.z, deg_to_rad(randf_range(-deg, deg)))

		var center_dir = bullet.transform.origin + dir

		bullet.global_position = weapon.get_barrel().global_position
		bullet.look_at(center_dir, Vector3.UP)
		bullet.apply_central_impulse(dir * bullet_velocity)

		bullets.append(bullet)

	args["bullets"] = bullets

	return args
