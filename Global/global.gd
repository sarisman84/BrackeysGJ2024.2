extends Node

enum PausedStates {NONE, WEAPON_SELECT, SHOP, PAUSE_MENU, MAX}

var player_ref : Node3D
var time_elapsed = 0.0
var player_at_shop = false
var current_currency : int = 0 :
	get:
		return current_currency
	set(value):
		var earned = value > current_currency
		if earned:
			on_currency_earned.emit()
		else:
			on_currency_lost.emit()
		current_currency = value

var current_paused_state : PausedStates = PausedStates.NONE

signal on_currency_earned
signal on_currency_lost

func _process(delta: float) -> void:
	time_elapsed += delta
