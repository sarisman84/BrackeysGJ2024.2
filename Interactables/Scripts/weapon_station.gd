class_name Shop
extends Area3D


func _on_body_entered(body : Variant) -> void:
	if body is not AvatarController:
		return
	body.shop.can_toggle_shop = true



func _on_body_exited(body) -> void:
	if body is not AvatarController:
		return
	body.shop.can_toggle_shop = false
