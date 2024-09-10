extends CanvasLayer

@onready var m_health_bar = $health_bar
@onready var m_coin_label = $coin_tab/coin_label
@onready var m_timer_label = $timer_tab/timer_label
@onready var m_ammo_label = $ammo_tab/container/ammo_label
@onready var weapon_icon = $ammo_tab/container/weapon_icon


func init(health_manager : HealthManager, weapon_manager : WeaponManager) -> void:
	#Connect health events to health ui
	health_manager.on_take_damage.connect(m_update_visual_health_bar.bind(health_manager.m_current_health))
	health_manager.on_heal.connect(m_update_visual_health_bar.bind(health_manager.m_current_health))

	#Connect currency events to currency ui
	Global.on_currency_earned.connect(m_update_visual_coins.bind(Global.current_currency))
	Global.on_currency_lost.connect(m_update_visual_coins.bind(Global.current_currency))

	#Connect weapon events to weapon ui
	weapon_manager.on_weapon_switch.connect(m_update_visual_ammo_counter.bind(weapon_manager))
	weapon_manager.on_weapon_fire.connect(m_update_visual_ammo_counter.bind(weapon_manager))
	weapon_manager.on_weapon_refill.connect(m_update_visual_ammo_counter.bind(weapon_manager))

func _process(_delta: float) -> void:
	m_update_time()
	visible = Global.current_paused_state == Global.PausedStates.NONE


func m_update_visual_health_bar(health: int) -> void:
	m_health_bar.value = health

func m_update_visual_coins(coins: int) -> void:
	m_coin_label.text = str(coins)

func m_update_visual_ammo_counter(weapon_manager : WeaponManager) -> void:
	var weapon = weapon_manager.m_weapon_inventory[weapon_manager.selected_weapon]
	m_ammo_label.text = "%d/%d" % [weapon.clip_size, weapon.m_current_clip_size]
	weapon_icon.texture = weapon.icon
	pass

func m_update_time() -> void:
	var minutes = int(Global.time_elapsed) / 60
	var seconds = int(Global.time_elapsed) % 60
	m_timer_label.text = "%d:%02d" % [minutes, seconds]
