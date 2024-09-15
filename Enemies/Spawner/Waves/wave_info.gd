extends Resource
class_name WaveInfo

@export var enemies : Array[PackedScene]
@export var spawn_distance = 15
@export var flying_distance = 10

@export var wave_start_time : float
@export var group_amount : int
@export var init_spawn_time_delay : float
@export var spawn_time_delay_decrease : float
@export var music_intensity : int
