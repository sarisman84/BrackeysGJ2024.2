extends CanvasLayer

@onready var weapon_label : RichTextLabel = $weapon_label

signal on_weapon_select_start
signal on_weapon_select_end
signal on_weapon_selected

var m_weapon_buttons : Array[TextureButton]
var m_weapon_labels : Array[String]


func _ready() -> void:
	for b in get_children():
		if b is TextureButton:
			m_weapon_buttons.append(b)
			m_weapon_labels.append("")
	weapon_label.text = ""
	visible = false

func _process(_delta : float) -> void:
	if not visible:
		return

	for i in range(m_weapon_buttons.size()):
		var b = m_weapon_buttons[i]
		if b.is_hovered():
			weapon_label.text = "[center]" + m_weapon_labels[i] + "[/center]"
			return
	weapon_label.text = ""

func enable_weapon_select(weapon_manager : WeaponManager) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	on_weapon_select_start.emit()
	visible = true

	for i in range(weapon_manager.m_weapon_inventory.size()):
		var b := m_weapon_buttons[i]
		var weapon := weapon_manager.m_weapon_inventory[i]
		var icon_holder = b.get_child(0) as TextureRect
		icon_holder.texture = weapon.icon
		b.button_down.connect(m_on_weapon_select.bind(weapon_manager, i))
		m_weapon_labels[i] = weapon.display_name

func disable_weapon_select(emit_event : bool = true) -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if emit_event:
		on_weapon_select_end.emit()

	for b in m_weapon_buttons:
		if b.button_down.is_connected(m_on_weapon_select):
			b.button_down.disconnect(m_on_weapon_select)
		var icon_holder = b.get_child(0) as TextureRect
		icon_holder.texture = null
	weapon_label.text = ""
	visible = false

func m_on_weapon_select(weapon_manager : WeaponManager, index : int) -> void:
	weapon_manager.selected_weapon_index = index
	on_weapon_selected.emit()
	disable_weapon_select(false)
	pass
