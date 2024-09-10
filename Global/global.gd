extends Node

var player_coords : Vector3 = Vector3.ZERO
var time_elapsed = 0.0
var player_at_shop = false
var player_money = 0

var money_scene = preload("res://Interactables/Scenes/money.tscn")

func _process(delta: float) -> void:
	time_elapsed += delta

func spawn_money(position, money_number, money_value):
	for i in money_number:
		var instance = money_scene.instantiate()
		instance.value = money_value
		instance.position = position
		instance.linear_velocity = velocity_randomize()
		get_tree().root.add_child(instance)

func velocity_randomize() -> Vector3:
	var output = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	output = output.normalized() * randf() * 3
	return output
