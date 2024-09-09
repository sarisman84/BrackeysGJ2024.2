extends Node
var m_weapon_behaviours : Dictionary = {}

func init() -> void:
	m_weapon_behaviours["fire_projectile"] = fire_projectile


func fire_projectile(weapon : BaseWeapon, owner : WeaponManager) -> void:
	var bullet = weapon.instantiate_scene(weapon.bullet_ins)
	owner.get_tree().root.add_child(bullet)

	bullet.global_position = weapon.get_barrel().global_position
	bullet.look_at(bullet.transform.origin + weapon.get_barrel().global_basis.z, Vector3.UP)
	bullet.init()
