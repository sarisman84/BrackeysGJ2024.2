extends Sprite3D

func _ready() -> void:
	await get_tree().create_timer(0.25).timeout
	queue_free()
