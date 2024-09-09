extends Node3D


func _on_area_body_entered(body: Node3D) -> void:
	print("yes")
	if body.is_in_group("Player"):
		print("yes")
		Global.player_at_shop = true

func _on_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Global.player_at_shop = false
