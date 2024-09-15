extends Node3D

func _ready() -> void:
	print(Global.player_ref.rotation)
	rotation = Global.player_ref.model.rotation
