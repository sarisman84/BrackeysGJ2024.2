extends RigidBody3D

var value = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Global.current_currency += value
		queue_free()
