extends CanvasLayer

signal back_button

func _on_back_button_pressed() -> void:
	back_button.emit()
