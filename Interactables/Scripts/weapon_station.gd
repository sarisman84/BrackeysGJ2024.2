class_name Shop
extends Area3D


func _on_body_entered(body : Variant) -> void:
	Global.player_at_shop = true
	if body is not AvatarController:
		return
	body.shop.can_toggle_shop = true



func _on_body_exited(body) -> void:
	Global.player_at_shop = false
	if body is not AvatarController:
		return
	body.shop.can_toggle_shop = false
