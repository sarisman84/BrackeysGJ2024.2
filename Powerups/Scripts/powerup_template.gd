extends RigidBody3D

@export var powerup_info : BasePowerup 
var powerups = ["SpeedUp", "MaxHealthUp", "JumpLimitUp", "AttackUp"]

#Powerup Details
var speed_up = 5
var jump_limit_up = 1
var attack_up = 0.5
var health_up = 5

func _ready() -> void:
	randomize_powerup()

func _on_area_body_entered(body: AvatarController) -> void:
	if body.is_in_group("Player"):
		powerup_obtained(body)
		queue_free()

func randomize_powerup():
	powerup_info.name = powerups.pick_random()

func powerup_obtained(player: AvatarController) -> void:
	match powerup_info.name:
		"SpeedUp":
			player.movement_speed += speed_up
		"MaxHealthUp":
			player.health_manager.max_health += health_up
			player.main_ui.m_update_visual_max_health(player.health_manager)
		"JumpLimitUp":
			player.jump_count += jump_limit_up
		"AttackUp":
			player.weapon_manager.damage_multiplier += attack_up
	player.main_ui.m_display_powerup_popup(powerup_info.name)
