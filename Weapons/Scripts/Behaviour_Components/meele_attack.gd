class_name MeeleAttack
extends BaseBehaviour

@export_group("Meele Attack Settings")
@export var hurtbox_shape : Shape3D
@export_flags_3d_physics var hurtbox_detection_mask : int
@export var delete_bullet_on_hit : bool = true
@export var slash_vfx : PackedScene

func m_create_hurtbox(owner : WeaponManager) -> Area3D:
	var hurtbox := Area3D.new()
	var col := CollisionShape3D.new()
	var vfx = slash_vfx.instantiate()
	
	col.shape = hurtbox_shape
	hurtbox.collision_mask = hurtbox_detection_mask

	hurtbox.add_child(col)
	hurtbox.add_child(vfx)
	owner.weapon_owner.get_parent().add_child(hurtbox)
	return hurtbox

func apply_behaviour(args : Dictionary = {}) -> Dictionary:
	assert(args.has("weapon"))
	assert(args.has("owner"))

	var weapon_manager : WeaponManager = args["owner"]
	var weapon : BaseWeapon = args["weapon"]

	var matrix = weapon.get_barrel().global_basis

	var hurtbox = m_create_hurtbox(weapon_manager)
	hurtbox.global_position = weapon.get_barrel().global_position

	var scene_tree = weapon_manager.get_tree()
	var timer = Timer.new()
	scene_tree.root.add_child(timer)
	timer.start(0.15)
	timer.timeout.connect(on_expire.bind(hurtbox, timer))

	args["hitbox"] = hurtbox
	return args

func on_expire(hitbox : Area3D, timer : Timer) -> void:
	hitbox.queue_free()
	timer.queue_free()
