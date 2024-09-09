extends CanvasLayer

@export var shop_items: Array[BaseWeapon]
var counter=0

@onready var m_icon = $VBoxContainer/HBoxContainer/icon
@onready var m_title = $VBoxContainer/title
@onready var m_cost = $VBoxContainer/cost

signal buy_weapon(item: BaseWeapon)

func _ready():
	update_visuals()
	hide_shop()
	show_shop()

func show_shop() -> void:
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_shop() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

#Update UI visuals
func update_visuals() -> void:
	m_icon.texture = shop_items[counter].icon
	m_title.text = shop_items[counter].display_name
	m_cost.text = str(shop_items[counter].weapon_cost)

#Scroll shop items
func _on_left_button_pressed() -> void:
	counter -= 1
	if counter < 0:
		counter += shop_items.size()
	update_visuals()
func _on_right_button_pressed() -> void:
	counter = (counter+1) % shop_items.size()
	update_visuals()

#Emit buy signal when buy button is pressed
func _on_buy_button_pressed():
	buy_weapon.emit(shop_items[counter])
