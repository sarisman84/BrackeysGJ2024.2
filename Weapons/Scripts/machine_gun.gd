extends BaseWeapon

@export var damage : float = 1.0
@export var bullet_instance : PackedScene

func fire() -> void:
	assert(bullet_instance)
	var ins = bullet_instance.instantiate() as Node3D
	get_tree().root.add_child(ins)
	ins.global_position = barrel_node.global_position
	ins.look_at(ins.transform.origin + barrel_node.global_basis.z, Vector3.UP)
	ins.init()
	pass
