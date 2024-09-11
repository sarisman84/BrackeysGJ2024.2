extends CanvasLayer

func _input(event: InputEvent) -> void:
	if Global.current_paused_state != Global.PausedStates.NONE and Global.current_paused_state != Global.PausedStates.PAUSE_MENU:
		return
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			_on_back_button_pressed()
		else:
				get_tree().paused = true
				show()
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
				Global.current_paused_state = Global.PausedStates.PAUSE_MENU

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.current_paused_state = Global.PausedStates.NONE
