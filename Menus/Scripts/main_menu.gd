extends CanvasLayer

@onready var m_background = $background
@onready var m_start_button = $background/start_button
@onready var m_options_button = $background/options_button
@onready var m_options = $options
@onready var m_button_click_sfx : FmodEventEmitter3D = $button_click_sfx
@onready var m_button_hover_sfx : FmodEventEmitter3D = $button_hover_sfx

@export_file("*.tscn") var game_scene : String

func _ready() -> void:
	m_options.back_button.connect(_on_options_back_button_pressed)
	m_start_button.mouse_entered.connect(func(): m_button_hover_sfx.play())
	m_options_button.mouse_entered.connect(func(): m_button_hover_sfx.play())

func _on_start_button_pressed() -> void:
	m_button_click_sfx.play()
	Loading.load_new_scene(game_scene)

func _on_options_button_pressed() -> void:
	m_options.show()
	m_background.hide()
	m_button_click_sfx.play()

func _on_options_back_button_pressed() -> void:
	m_options.hide()
	m_background.show()
	m_button_click_sfx.play()
