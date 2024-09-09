extends CanvasLayer

@onready var m_health_bar = $health_bar
@onready var m_coin_label = $coin_tab/coin_label
@onready var m_timer_label = $timer_tab/timer_label
@onready var m_timer = $timer

var seconds_elapsed = 0

func m_update_visual_health_bar(health: int) -> void:
	m_health_bar.value = health

func m_update_visual_coins(coins: int) -> void:
	m_coin_label.text = str(coins)

func _on_timer_timeout() -> void:
	seconds_elapsed +=1
	update_ui()

func update_ui() -> void:
	var minutes = seconds_elapsed / 60
	var seconds = seconds_elapsed % 60
	m_timer_label.text = "%d:%02d" % [minutes, seconds]

func pause_timer() -> void:
	m_timer.paused = true

func resume_timer() -> void:
	m_timer.paused = false
 
