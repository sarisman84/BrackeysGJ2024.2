extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if get_tree().paused:
			_on_back_button_pressed()
		else:
			get_tree().paused = true
			show()
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_back_button_pressed() -> void:
	get_tree().paused = false
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
