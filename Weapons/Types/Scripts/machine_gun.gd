class_name MachineGun
extends BaseWeapon

@export var damage : float = 1.0
@export_file("*.tscn") var bullet_instance : String

func fire(owner : Node3D) -> void:
	assert(bullet_instance)
	var ins = instantiate_model(bullet_instance)
	owner.get_tree().root.add_child(ins)

	ins.global_position = get_barrel().global_position
	ins.look_at(ins.transform.origin + get_barrel().global_basis.z, Vector3.UP)
	ins.init()
	pass
