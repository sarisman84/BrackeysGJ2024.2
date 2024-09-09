extends Area3D

@export var damage_amount = 1

func _on_body_entered(body: Node3D) -> void:
	if body is HealthManager:
		body.take_damage(damage_amount)
