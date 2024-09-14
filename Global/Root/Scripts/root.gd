extends Node

@export_file("*.tscn") var scene_to_load : String

func _ready() -> void:
	Loading.on_load_start.connect(m_load_scene)
	Loading.on_load_end.connect(func(): get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_to_load)))
	Loading.initiate(m_load_complete)



func m_load_scene() -> void:
	ItemRegistry.initialize_spawn_items(4)
	ResourceLoader.load_threaded_request(scene_to_load)

func m_load_complete() -> bool:
	return ItemRegistry.has_finished_spawning_items() and ResourceLoader.load_threaded_get_status(scene_to_load) == ResourceLoader.THREAD_LOAD_LOADED
