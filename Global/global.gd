extends Node

var player_coords : Vector3 = Vector3.ZERO
var time_elapsed = 0.0

func _process(delta: float) -> void:
	time_elapsed += delta
