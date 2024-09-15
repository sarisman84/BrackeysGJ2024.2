extends Node

#enum Type {FIRE_SINGLE_PROJECTILE, FIRE_MULTIPLE_PROJECTILES, HITSCAN, MAX}
#
#var m_weapon_behaviours : Dictionary = {}
#
#func init() -> void:
	#m_weapon_behaviours[Type.FIRE_SINGLE_PROJECTILE] = fire_projectile
##
##
#func fire_projectile(weapon : BaseWeapon, owner : WeaponManager) -> void:
	#var bullet = weapon.instantiate_scene(weapon.bullet_ins)
	#owner.get_tree().root.add_child(bullet)
#
	#bullet.global_position = weapon.get_barrel().global_position
	#bullet.look_at(bullet.transform.origin + weapon.get_barrel().global_basis.z, Vector3.UP)
	#bullet.init(owner.get_parent())


#func evaluate_behaviour(input : String, execution_owner : Object, locals : Dictionary = {}) -> void:
	#var bullet
	#var lines = input.split("\n")
	#for i in range(lines.size()):
		#var expression = Expression.new()
		#var line = lines[i]
		#var err = expression.parse(line, PackedStringArray(locals.keys()))
		#if err != OK:
			#push_error("[%s]: at line %d: %s" % [execution_owner.get_script().get_global_name(), i, expression.get_error_text()])
			#return
#
		#expression.execute(locals.values(), execution_owner)
