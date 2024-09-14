extends CanvasLayer

var m_shop_items: Array[BaseWeapon]
var m_shop_bought_flags : Array[bool]
var m_weapon_manager : WeaponManager
var m_counter=0

@onready var m_icon = $shop_window/main_icon/texture
@onready var m_left_icon = $shop_window/main_icon/left_button/texture
@onready var m_right_icon = $shop_window/main_icon/right_button/texture
@onready var m_title = $shop_window/title
@onready var m_buy = $shop_window/buy/buy_label


var can_toggle_shop : bool

func _ready():
	m_get_weapons_from_registry()
	m_update_visuals()
	hide_shop()


func _process(_delta : float) -> void:
	if not can_toggle_shop:
		return

	if Global.current_paused_state != Global.PausedStates.NONE and Global.current_paused_state != Global.PausedStates.SHOP:
		return


	if Input.is_action_just_pressed("interact"):
		if visible:
			hide_shop()
		else:
			show_shop()


func show_shop() -> void:
	show()
	m_update_visuals()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	Global.current_paused_state = Global.PausedStates.SHOP

func hide_shop() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	Global.current_paused_state = Global.PausedStates.NONE

func is_open() -> bool:
	return visible

func init(weapon_manager : WeaponManager) -> void:
	m_weapon_manager = weapon_manager


#Update UI visuals
func m_update_visuals() -> void:
	var has_weapon_already : bool

	var local_weapon : BaseWeapon = m_shop_items[m_counter]
	if m_weapon_manager:
		var potential_weapon = m_weapon_manager.get_weapon(m_shop_items[m_counter].UUID)
		if potential_weapon:
			local_weapon = potential_weapon
			has_weapon_already = local_weapon != null

	m_icon.texture = local_weapon.icon
	m_title.text = local_weapon.display_name

	#Update left and right button icons
	var temp = m_counter - 1
	if temp < 0:
		temp += m_shop_items.size()
	m_left_icon.texture = m_shop_items[temp].icon
	temp = (temp + 2) % m_shop_items.size()
	m_right_icon.texture = m_shop_items[temp].icon

	if not has_weapon_already:
		m_buy.text = "Buy for %d" % local_weapon.weapon_cost
		return
	if local_weapon.m_current_clip_size == local_weapon.clip_size:
		m_buy.text = "Ammo Full"
		return

	var required_ammo_to_fill = local_weapon.clip_size - local_weapon.m_current_clip_size
	m_buy.text = "Buy %d Ammo for %d" % [required_ammo_to_fill, required_ammo_to_fill * local_weapon.ammo_cost]

func m_get_weapons_from_registry() -> void:
	for item in ItemRegistry.item_registry:
		if item is BaseWeapon:
			if item.sellable:
				m_shop_items.append(item.duplicate())

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
	var money = Global.current_currency
	var weapon_data = m_weapon_manager.get_weapon(m_shop_items[m_counter].UUID)
	if not weapon_data:
		weapon_data = m_shop_items[m_counter]
	#if the player already owns the current weapon, try to buy ammo for it instead
	if m_weapon_manager.get_weapon(m_shop_items[m_counter].UUID):
		#Calculate how much remaining ammo the player has left on the current gun
		var required_ammo_to_fill = weapon_data.clip_size - weapon_data.m_current_clip_size
		var ammo_cost = required_ammo_to_fill * weapon_data.ammo_cost

		#Reduce their money based on the cost of the ammo and make em refill the gun with the required amount.
		if ammo_cost <= money and required_ammo_to_fill != 0:
			Global.current_currency -= ammo_cost
			m_weapon_manager.refill_ammo_for(m_shop_items[m_counter].UUID, required_ammo_to_fill)
	#Attempt to buy the current gun instead.
	elif weapon_data.weapon_cost <= money:
		Global.current_currency -= weapon_data.weapon_cost
		m_weapon_manager.add_weapon(m_shop_items[m_counter].UUID)

	m_update_visuals()
