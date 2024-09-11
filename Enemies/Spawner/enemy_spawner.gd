extends Node3D

@onready var m_group_timer = $group_timer
@onready var m_downtime_timer = $downtime_timer

#Wave Manager
@export var wave_info_array : Array[WaveInfo]
var cur_wave = 0
var groups_spawned = 0
var minimum_spawn_time = 1.0
@export var enemy_limit = 30

var spawn_margin = 15
var raycast_result

func _ready() -> void:
	start_wave_countdown()

func _physics_process(_delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var position = position_randomize()
	var start = position + Vector3(0, spawn_margin, 0)
	var end = position - Vector3(0, spawn_margin, 0)
	var query = PhysicsRayQueryParameters3D.create(start, end)
	
	var result = space_state.intersect_ray(query)
	if result != {}:
		raycast_result = result

func start_wave_countdown():
	m_downtime_timer.start(wave_info_array[cur_wave].wave_start_time - Global.time_elapsed)
	m_group_timer.wait_time = wave_info_array[cur_wave].init_spawn_time_delay
	groups_spawned = 0

func position_randomize() -> Vector3:
	var output = Vector3(randf_range(-1,1), 0, randf_range(-1,1))
	output = (output.normalized() * wave_info_array[cur_wave].spawn_distance) + Global.player_ref.global_position
	return output

func _on_timer_timeout() -> void:
	if groups_spawned < wave_info_array[cur_wave].group_amount:
		spawn_group()
		groups_spawned += 1
		m_group_timer.start(m_group_timer.wait_time - wave_info_array[cur_wave].spawn_time_delay_decrease)
	else:
		cur_wave += 1
		start_wave_countdown()

func spawn_group() -> void:
	if get_child_count() < 30:
		for i in randi_range(1, cur_wave + 2):
			var enemies = wave_info_array[cur_wave].enemies
			var chosen_enemy = randi_range(0, enemies.size() - 1)
			var instance = enemies[chosen_enemy].instantiate()
			instance.position = raycast_result.position
			instance.position.y += 1.5
			if chosen_enemy == 1:
				instance.position.y += wave_info_array[cur_wave].flying_distance
			add_child(instance)
			await get_tree().create_timer(0.375).timeout
