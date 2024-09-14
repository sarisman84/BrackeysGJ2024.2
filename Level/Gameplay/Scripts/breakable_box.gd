extends RigidBody3D

@export var drop_setting : SpawnSetting

@onready var hurtbox : HealthManager = $hurtbox

func _ready() -> void:
	hurtbox.health_owner = self
	hurtbox.on_death.connect(m_spawn_drop)
	#drop_setting.load_object()

func m_spawn_drop() -> void:
	#assert(drop_setting, "[Breakable Crates]: %s has no drop setting!" % name)

	if not drop_setting:
		Global.spawn_money(global_position,randi_range(3, 5), 100)
		ItemRegistry.reset_cached_item(self)
		return
	var chance = randf()
	if chance < drop_setting.chance_to_spawn:
		drop_setting.spawn_object(global_position)
		print("[Breakable Crates]: Dropped %s" % drop_setting.resource_name)

	ItemRegistry.reset_cached_item(self)
