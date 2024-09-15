extends RigidBody3D

@onready var m_gear_mesh = $gear_mesh


var value = 10
var fly_distance = 6
var jump_triggered = false
var pickup_sfx_name : String = "event:/Player/Currency Pickup"
var pickup_sfx_guid : String = "{059c0e4a-cbe8-45f0-8dbf-d38edcb80b05}"

var fly_speed = 20
var jump_speed = 300

var m_picked_up_flag : bool = false
var m_internal_clock : float

#Mesh settings
var rotation_dir
var rotation_speed

func _ready() -> void:
	const SPAWN_VELOCITY = 2.5
	apply_central_impulse(Vector3(randf_range(-1, 1) , 1,randf_range(-1, 1)).normalized() * SPAWN_VELOCITY)

	rotation_dir = [-1, 1].pick_random()
	rotation_speed = randf_range(0.02, 0.05)
	var size = randf_range(0.1, 0.18)
	m_gear_mesh.scale = Vector3(size, size, size)

func _physics_process(_delta: float) -> void:
	if (Global.player_ref.position - position).length() < fly_distance and not m_picked_up_flag:
		m_picked_up_flag = true
		m_internal_clock = fly_speed

	if m_picked_up_flag:
		m_internal_clock += _delta * 10.0
		apply_central_force((Global.player_ref.position - position).normalized() * m_internal_clock)
		jump_once()
	m_gear_mesh.rotate_y(rotation_dir * rotation_speed)

func jump_once() -> void:
	if jump_triggered:
		return
	if Global.player_ref.position.y > position.y:
		jump_triggered = true
		apply_central_force(Vector3(0, jump_speed, 0))

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Global.current_currency = Global.current_currency + value

		var emitter := FmodEventEmitter3D.new()
		emitter.preload_event = false
		emitter.event_name = pickup_sfx_name
		emitter.event_guid = pickup_sfx_guid

		get_tree().root.add_child(emitter)
		emitter.global_position = global_position

		emitter.play()

		var timer := Timer.new()
		get_tree().root.add_child(timer)
		timer.timeout.connect(m_clear_sfx.bind(emitter, timer))
		timer.start(0.5)


	queue_free()

func m_clear_sfx(emitter : FmodEventEmitter3D, timer : Timer) -> void:
	if emitter:
		emitter.queue_free()
	if timer:
		timer.queue_free()
