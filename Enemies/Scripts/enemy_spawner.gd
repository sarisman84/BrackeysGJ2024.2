extends Node3D

@onready var m_wave_timer = $wave_timer
@onready var m_downtime_timer = $downtime_timer

@export var enemies : Array[PackedScene]
@export var spawn_distance = 15
@export var flying_distance = 10
@export var timer_decrease = 0.1
@export var timer_limit = 1.0

var waves_spawned = 0:
	set(value):
		waves_spawned = value
		#Transition to Phase 2
		if value == 10:
			enemy_picker_limit = 1
			start_downtime()
			return
		#Transition to Phase 3
		elif value == 20:
			enemy_picker_limit = 2
			start_downtime()
			return
		
		if m_wave_timer.wait_time > timer_limit:
			m_wave_timer.start(m_wave_timer.wait_time - timer_decrease)
		else:
			m_wave_timer.start()
var enemy_picker_limit = 0

func position_randomize() -> Vector3:
	var output = Vector3(randf_range(-1,1), 0, randf_range(-1,1))
	output = (output.normalized() * spawn_distance) + Global.player_coords
	return output

func _on_timer_timeout() -> void:
	spawn_wave()
	waves_spawned += 1

func spawn_wave() -> void:
	for i in randi_range(1, enemy_picker_limit + 2):
		var chosen_enemy = randi_range(0, enemy_picker_limit)
		var scene = enemies[chosen_enemy].instantiate()
		scene.position = position_randomize()
		if chosen_enemy == 1:
			scene.position.y += flying_distance
		add_child(scene)

func start_downtime() -> void:
	m_downtime_timer.start()
