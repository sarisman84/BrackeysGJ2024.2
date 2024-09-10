extends CanvasLayer

@onready var weapon_label : RichTextLabel = $weapon_label

signal on_weapon_select_start
signal on_weapon_select_end
signal on_weapon_selected

var m_weapon_buttons : Array[TextureButton]
var m_weapon_labels : Array[String]
var m_weapon_manager : WeaponManager


func _ready() -> void:
	#Fetch all Available Weapon Buttons and the Center Label
	for b in get_children():
		if b is TextureButton:
			m_weapon_buttons.append(b)
			m_weapon_labels.append("")
	weapon_label.text = ""
	visible = false

func _process(_delta : float) -> void:
	#Close Weapon Select if we are paused in another state.
	if Global.current_paused_state != Global.PausedStates.NONE and Global.current_paused_state != Global.PausedStates.WEAPON_SELECT:
		disable_weapon_select(m_weapon_manager, false)
		return

	#Handle Weapon Select Input
	if Input.is_action_just_pressed("weapon_select"):
		if not visible:
			enable_weapon_select(m_weapon_manager)
		else:
			disable_weapon_select(m_weapon_manager)

	if not visible:
		return

	#Update the label based on where the user has hovered
	for i in range(m_weapon_buttons.size()):
		var b = m_weapon_buttons[i]
		if b.is_hovered():
			weapon_label.text = "[center]" + m_weapon_labels[i] + "[/center]"
			return
	#Reset the label if the user hasnt hovered over anything yet.
	weapon_label.text = ""

func init(weapon_manager : WeaponManager) -> void:
	m_weapon_manager = weapon_manager

func enable_weapon_select(weapon_manager : WeaponManager) -> void:
	#Uncapture the mouse from the middle of the screen
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	#Set Pause State to Weapon Select
	Global.current_paused_state = Global.PausedStates.WEAPON_SELECT

	#Pause the game
	get_tree().paused = true

	#Emit Event
	on_weapon_select_start.emit()

	#Show self
	visible = true

	#Disable Primary Fire
	weapon_manager.fire_input_override = true

	#Fetch weapon inventory
	var weapon_inv = weapon_manager.m_weapon_inventory

	#Update every button with user's current inventory
	for i in range(weapon_inv.size()):
		#Fetch button and weapon info
		var b := m_weapon_buttons[i]
		var weapon : BaseWeapon = weapon_inv[i]
		var icon_holder = b.get_child(0) as TextureRect

		#Apply Weapon Icon, Event and Name to Button
		icon_holder.texture = weapon.icon
		b.button_down.connect(m_on_weapon_select.bind(weapon_manager, i))
		m_weapon_labels[i] = weapon.display_name

func disable_weapon_select(weapon_manager : WeaponManager, update_mouse_mode : bool = true, emit_event : bool = true) -> void:
	#Exit the method if we are already disabled
	if not visible:
		return
	#Update Mouse Mode
	if update_mouse_mode:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	#Set Pause State to None
	Global.current_paused_state = Global.PausedStates.NONE

	#Unpause the game
	get_tree().paused = false

	#Enable Primary Fire
	weapon_manager.fire_input_override = false

	#Emit Event if Applicable
	if emit_event:
		on_weapon_select_end.emit()

	#Reset every button
	for b in m_weapon_buttons:
		if b.button_down.is_connected(m_on_weapon_select):
			b.button_down.disconnect(m_on_weapon_select)
		var icon_holder = b.get_child(0) as TextureRect
		icon_holder.texture = null

	#Reset label
	weapon_label.text = ""

	#Finally, turn self off.
	visible = false

func m_on_weapon_select(weapon_manager : WeaponManager, index : int) -> void:
	weapon_manager.selected_weapon = index
	on_weapon_selected.emit()
	disable_weapon_select(weapon_manager,true,false)
	pass
