extends Area3D

@export var damage_amount = 1

func _on_body_entered(body: Node3D) -> void:
	if body is not HealthManager or body.owner.get_instance_id() == owner.get_instance_id():
		return
	var hm = body as HealthManager
	hm.take_damage(damage_amount)
	print("[enemy - %s]: Attacking %s!\n%s Health: %d" % [owner.name, body.owner.name, body.owner.name, hm.m_current_health])
