extends CanvasLayer
class_name MainUI

@onready var m_health_bar = $health_bar
@onready var m_coin_label = $coin_tab/coin_label
@onready var m_timer_label = $timer_tab/timer_label
@onready var m_ammo_label = $ammo_tab/container/ammo_label
@onready var weapon_icon = $ammo_tab/container/weapon_icon
@onready var m_popup_label = $popup_label
@onready var m_animation_player = $animation_player

func init(health_manager : HealthManager, weapon_manager : WeaponManager) -> void:
	#Connect health events to health ui
	health_manager.on_take_damage.connect(m_update_visual_health_bar.bind(health_manager))
	health_manager.on_heal.connect(m_update_visual_health_bar.bind(health_manager))

	#Connect currency events to currency ui
	Global.on_currency_earned.connect(m_update_visual_coins)
	Global.on_currency_lost.connect(m_update_visual_coins)

	#Connect weapon events to weapon ui
	weapon_manager.on_weapon_switch.connect(m_update_visual_ammo_counter.bind(weapon_manager))
	weapon_manager.on_weapon_fire.connect(m_update_visual_ammo_counter.bind(weapon_manager))
	weapon_manager.on_weapon_refill.connect(m_update_visual_ammo_counter.bind(weapon_manager))

func _ready() -> void:
	m_popup_label.modulate = Color("ffffff", 0)

func _process(_delta: float) -> void:
	m_update_time()
	visible = Global.current_paused_state == Global.PausedStates.NONE

func m_update_visual_max_health(health_manager: HealthManager) -> void:
	m_health_bar.max_value = health_manager.max_health

func m_update_visual_health_bar(health_manager: HealthManager) -> void:
	m_health_bar.value = health_manager.m_current_health

func m_update_visual_coins() -> void:
	m_coin_label.text = str(Global.current_currency)

func m_update_visual_ammo_counter(weapon_manager : WeaponManager) -> void:
	var weapon = weapon_manager.m_weapon_inventory[weapon_manager.selected_weapon]
	m_ammo_label.text = "%d/%d" % [weapon.m_current_clip_size, weapon.clip_size]
	weapon_icon.texture = weapon.icon
	pass

func m_update_time() -> void:
	var minutes = int(Global.time_elapsed) / 60
	var seconds = int(Global.time_elapsed) % 60
	m_timer_label.text = "%d:%02d" % [minutes, seconds]

func m_display_powerup_popup(powerup_name: String) -> void:
	m_popup_label.modulate = Color("ffffff", 1)
	m_popup_label.text = "You picked up a %s powerup!" % powerup_name.capitalize()
	await get_tree().create_timer(3.0).timeout
	m_animation_player.play("fade_out_popup")
