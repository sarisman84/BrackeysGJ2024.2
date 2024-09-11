extends Node

enum PausedStates {NONE, WEAPON_SELECT, SHOP, PAUSE_MENU, GAME_OVER, MAX}

var player_ref : Node3D
var time_elapsed = 0.0
var player_at_shop = false
var current_currency : int = 0 :
	set(value):
		current_currency = value
		var earned = value > current_currency
		if earned:
			on_currency_earned.emit()
		else:
			on_currency_lost.emit()

var current_paused_state : PausedStates = PausedStates.NONE

signal on_currency_earned
signal on_currency_lost

var money_scene = preload("res://Interactables/Scenes/money.tscn")

func _process(delta: float) -> void:
	time_elapsed += delta

func spawn_money(position, money_number, money_value):
	for i in money_number:
		var instance = money_scene.instantiate()
		instance.value = money_value
		instance.position = position
		instance.linear_velocity = velocity_randomize()
		player_ref.get_parent().add_child(instance)

func velocity_randomize() -> Vector3:
	var output = Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1))
	output = output.normalized() * randf() * 3
	return output
