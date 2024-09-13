class_name OnHitBehaviour
extends BaseBehaviour

@export_group("Bullet On Hit Settings")
@export var hurtbox_shape : Shape3D
@export_flags_3d_physics var hurtbox_detection_mask : int
@export var delete_bullet_on_hit : bool = true

func m_create_hurtbox(bullet : Node3D) -> Area3D:
	var hurtbox := Area3D.new()
	var col := CollisionShape3D.new()

	col.shape = hurtbox_shape
	hurtbox.collision_mask = hurtbox_detection_mask

	hurtbox.add_child(col)
	bullet.add_child(hurtbox)
	return hurtbox

func apply_behaviour(args : Dictionary = {}) -> Dictionary:
	assert(args.has("weapon"))
	assert(args.has("owner"))
	assert(args.has("bullets"))

	var bullets = args["bullets"]
	var weapon_manager : WeaponManager = args["owner"]
	var damage_multiplier : float = args["damage_multiplier"]

	for bullet in bullets:
		var hurtbox = m_create_hurtbox(bullet)
		hurtbox.body_entered.connect(func(incoming_body : Variant): on_bullet_hit(bullet, weapon_manager,damage_multiplier, incoming_body))
		hurtbox.area_entered.connect(func(incoming_body : Variant): on_bullet_hit(bullet, weapon_manager,damage_multiplier, incoming_body))
	return args

func on_bullet_hit(bullet : Node3D, weapon_manager: WeaponManager,damage_multiplier : float, incoming_body : Variant) -> void:
	pass
