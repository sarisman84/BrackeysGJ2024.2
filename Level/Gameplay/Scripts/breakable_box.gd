extends RigidBody3D

@export var drop_setting : SpawnSetting
@export_group("SFX")
@export var crate_break_sfx_name : String
@export var crate_break_sfx_guid : String

@onready var hurtbox : HealthManager = $hurtbox

@export_group("Heal")
@export var heal_player : bool = false
@export var heal_amount : int = 1

func _ready() -> void:
	hurtbox.health_owner = self
	hurtbox.on_death.connect(m_spawn_drop)
	#drop_setting.load_object()

func m_spawn_drop() -> void:
	#assert(drop_setting, "[Breakable Crates]: %s has no drop setting!" % name)
	if heal_player:
		Global.player_ref.health_manager.heal(heal_amount)
		ItemRegistry.reset_cached_item(self)
		return
	if not drop_setting:
		Global.spawn_money(global_position,randi_range(3, 5), 100)
		ItemRegistry.reset_cached_item(self)
		return
	var chance = randf()
	if chance < drop_setting.chance_to_spawn:
		drop_setting.spawn_object(global_position)
		print("[Breakable Crates]: Dropped %s" % drop_setting.resource_name)

	ItemRegistry.reset_cached_item(self)

	var emitter := FmodEventEmitter3D.new()
	emitter.preload_event = false
	emitter.event_name = crate_break_sfx_name
	emitter.event_guid = crate_break_sfx_guid
	emitter.global_position = global_position
	get_tree().root.add_child(emitter)
	emitter.play()

	var timer := Timer.new()
	timer.start(0.5)
	timer.timeout.connect(m_clear_sfx.bind(emitter))

func m_clear_sfx(emitter : FmodEventEmitter3D) -> void:
	emitter.queue_free()
