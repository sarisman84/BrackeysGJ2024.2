extends CanvasLayer

@onready var m_background = $background
@onready var m_options = $options

@export var game_scene : PackedScene

func _ready() -> void:
	m_options.back_button.connect(_on_options_back_button_pressed)

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(game_scene)

func _on_options_button_pressed() -> void:
	m_options.show()
	m_background.hide()

func _on_options_back_button_pressed() -> void:
	m_options.hide()
	m_background.show()
