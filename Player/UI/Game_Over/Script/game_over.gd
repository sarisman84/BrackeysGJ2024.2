extends CanvasLayer

@export_file("*.tscn") var quit_scene : String

@onready var play = %play
@onready var quit = %quit
@onready var gear_count_label = %gear_count
@onready var time_survived_label = %time_survived

func _ready() -> void:
	play.button_down.connect(m_on_play)
	quit.button_down.connect(m_on_quit)

func transition(player : AvatarController) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	m_enable()
	player.model.hide()


func m_enable() -> void:
	show()
	Global.current_paused_state = Global.PausedStates.GAME_OVER
	gear_count_label.text = "Gears Collected: %d" % Global.current_currency
	var minutes = int(Global.time_elapsed) / 60
	var seconds = int(Global.time_elapsed) % 60
	time_survived_label.text = "Time Survived: %d:%02d" % [minutes, seconds]
	get_tree().paused = true


func m_disable() -> void:
	hide()
	Global.current_paused_state = Global.PausedStates.NONE
	get_tree().paused = false

func m_on_play() -> void:
	ItemRegistry.reset_all_spawned_items()
	m_disable()
	Loading.reload_scene(owner.get_tree())
	#owner.get_tree().reload_current_scene()
	Global.time_elapsed = 0.0



func m_on_quit() -> void:
	ItemRegistry.reset_all_spawned_items()
	m_disable()
	Loading.load_new_scene(quit_scene)
	#get_tree().change_scene_to_file(quit_scene)
