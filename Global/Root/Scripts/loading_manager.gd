extends Node

@onready var loading_animation : AnimationPlayer = $loading_screen/loading_animation
@onready var loading_screen = $loading_screen

signal on_load_start
signal on_load_end

const LOADING_IDLE = 0
const LOADING_START = 1
const LOADING_PROGRESS = 2
const LOADING_END = 3

var m_current_state : int = 0
var m_callable : Callable

func initiate(loading_complete_condition = null) -> void:
	if m_current_state != LOADING_IDLE:
		return
	if loading_complete_condition:
		m_callable = loading_complete_condition
	loading_animation.play("loading_fade_in")
	m_current_state = LOADING_START
	on_load_start.emit()
	loading_screen.visible = true

func reload_scene(scene_to_reload) -> void:
	on_load_end.connect(func(): scene_to_reload.reload_current_scene())
	initiate()

func load_new_scene(new_scene : String) -> void:
	on_load_start.connect(func(): ResourceLoader.load_threaded_request(new_scene))
	on_load_end.connect(func(): get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(new_scene)))
	initiate(func(): return ResourceLoader.load_threaded_get_status(new_scene) == ResourceLoader.THREAD_LOAD_LOADED)

func _process(_delta : float) -> void:
	match m_current_state:
		LOADING_START:
			if not loading_animation.is_playing():
				loading_animation.play("loading_animation")
				m_current_state = LOADING_PROGRESS
		LOADING_PROGRESS:
			get_tree().paused = true
			if not m_callable or not m_callable.is_valid() or m_callable.call():
				loading_animation.play("loading_fade_out")
				m_current_state = LOADING_END
				on_load_end.emit()
				get_tree().paused = false
		LOADING_END:
			if not loading_animation.is_playing():
				m_current_state = LOADING_IDLE
				loading_screen.visible = false

				var data = on_load_start.get_connections()
				for d in data:
					on_load_start.disconnect(d["callable"])
				data = on_load_end.get_connections()
				for d in data:
					on_load_end.disconnect(d["callable"])
