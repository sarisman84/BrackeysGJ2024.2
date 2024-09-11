extends Area3D

@onready var m_timer = $timer

@export var damage_amount = 1
@export var damage_cooldown = 3

var array : Array

func _ready() -> void:
	m_timer.wait_time = damage_cooldown

func _on_body_entered(body: Node3D) -> void:
	if body is not HealthManager or body.owner.get_instance_id() == owner.get_instance_id():
		return
	var hm = body as HealthManager
	hm.take_damage(damage_amount)
	array.append(hm)
	m_timer.start()
	#print("[enemy - %s]: Attacking %s!\n%s Health: %d" % [owner.name, body.owner.name, body.owner.name, hm.m_current_health])

func _on_body_exited(body: Node3D) -> void:
	var hm = body as HealthManager
	array.erase(hm)

func _on_timer_timeout() -> void:
	if !array.is_empty():
		for hm in array:
			hm.take_damage(damage_amount)
