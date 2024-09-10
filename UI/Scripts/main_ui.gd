extends CanvasLayer

@onready var m_health_bar = $health_bar
@onready var m_coin_label = $coin_tab/coin_label
@onready var m_timer_label = $timer_tab/timer_label

func _process(delta: float) -> void:
	update_ui()

func m_update_visual_health_bar(health: int) -> void:
	m_health_bar.value = health

func m_update_visual_coins(coins: int) -> void:
	m_coin_label.text = str(coins)

func update_ui() -> void:
	var minutes = int(Global.time_elapsed) / 60
	var seconds = int(Global.time_elapsed) % 60
	m_timer_label.text = "%d:%02d" % [minutes, seconds]
	
	m_coin_label.text = str(Global.player_money)
