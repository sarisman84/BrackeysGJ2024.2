extends RigidBody3D

@export var drop_setting : SpawnSetting

@onready var hurtbox : HealthManager = $hurtbox

func _ready() -> void:
	hurtbox.health_owner = self
	hurtbox.on_death.connect(m_spawn_drop)

func m_spawn_drop() -> void:
	assert(drop_setting, "[Breakable Crates]: %s has no drop setting!" % name)

	var chance = randf()
	if chance < drop_setting.chance_to_spawn:
		drop_setting.spawn_object(get_parent(), self)
		print("[Breakable Crates]: Dropped %s" % drop_setting.resource_name)

	queue_free()
