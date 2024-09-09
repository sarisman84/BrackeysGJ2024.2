extends CanvasLayer

var m_shop_items: Array[BaseWeapon]
var m_shop_bought_flags : Array[bool]
var m_weapon_manager : WeaponManager
var m_counter=0

@onready var m_icon = $VBoxContainer/HBoxContainer/icon
@onready var m_title = $VBoxContainer/title
@onready var m_cost = $VBoxContainer/cost


func _ready():
	m_get_weapons_from_registry()
	m_update_visuals()
	hide_shop()
	show_shop()

func show_shop() -> void:
	show()
	m_update()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func hide_shop() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func init(weapon_manager : WeaponManager) -> void:
	m_weapon_manager = weapon_manager

func m_update() -> void:
	var weapon_col = m_weapon_manager.m_weapon_inventory

	for i in range(m_shop_items.size()):
		var wep = m_shop_items[i]
		m_shop_bought_flags[i] = weapon_col.find_key(wep)

#Update UI visuals
func m_update_visuals() -> void:
	var has_weapon_already = m_shop_bought_flags[m_counter]

	m_icon.texture = m_shop_items[m_counter].icon
	if has_weapon_already:
		m_title.text = "%s Ammo" % m_shop_items[m_counter].display_name
		m_cost.text = str(m_shop_items[m_counter].ammo_cost)
	else:
		m_title.text = m_shop_items[m_counter].display_name
		m_cost.text = str(m_shop_items[m_counter].weapon_cost)


func m_get_weapons_from_registry() -> void:
	for item in ItemRegistry.item_registry:
		if item is BaseWeapon:
			m_shop_items.append(item.duplicate())
			m_shop_bought_flags.append(false)

#Scroll shop items
func _on_left_button_pressed() -> void:
	m_counter -= 1
	if m_counter < 0:
		m_counter += m_shop_items.size()
	m_update_visuals()
func _on_right_button_pressed() -> void:
	m_counter = (m_counter+1) % m_shop_items.size()
	m_update_visuals()

#Emit buy signal when buy button is pressed
func _on_buy_button_pressed():
	var money = Global.money_earned
	var weapon_data = m_shop_items[m_counter]

	#if the player already owns the current weapon, try to buy ammo for it instead
	if m_shop_bought_flags[m_counter]:
		#Calculate how much remaining ammo the player has left on the current gun
		var required_ammo_to_fill = weapon_data.clip_size - weapon_data.m_current_clip_size
		var ammo_cost = required_ammo_to_fill * weapon_data.ammo_cost

		#Reduce their money based on the cost of the ammo and make em refill the gun with the required amount.
		if ammo_cost <= money:
			Global.money_earned -= ammo_cost
			m_weapon_manager.refill_ammo_for(m_shop_items[m_counter].UUID, required_ammo_to_fill)
		return
	#Attempt to buy the current gun instead.
	if weapon_data.weapon_cost <= money:
		Global.money_earned -= weapon_data.weapon_cost
		m_weapon_manager.add_weapon(m_shop_items[m_counter].UUID)
		m_update()
