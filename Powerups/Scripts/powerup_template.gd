extends RigidBody3D

@export var powerup_name : Powerup

signal powerup_obtained(name)

func _on_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		powerup_obtained.emit(powerup_name)
		queue_free()
