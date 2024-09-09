extends CanvasLayer

@export var shop_items:Array[BaseWeapon]
var counter=0

@onready var m_icon = $VBoxContainer/icon
@onready var m_title = $VBoxContainer/title
@onready var m_cost = $VBoxContainer/cost

signal buy_weapon(item: BaseWeapon)

func _ready():
	update_visuals()

#Update UI visuals
func update_visuals() -> void:
	pass
	#m_icon.texture = shop_items[counter].texture
	#m_title.text = shop_items[counter].title
	#m_cost.text = str(shop_items[counter].cost)

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
