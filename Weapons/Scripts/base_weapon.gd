extends BaseResource
class_name BaseWeapon

#@export_custom(PROPERTY_HINT_EXPRESSION,"") var fire_behaviour : String
@export_group("Functional")
@export var fire_behaviour : String
@export var damage : int = 1.0
@export_file("*tscn") var bullet_ins : String
@export var fire_rate : float = 0.5
@export var clip_size : int = 10
@export_group("Visual")
@export_file("*.tscn") var model : String
@export var icon : Texture2D
@export var display_name : String
@export_group("Costs")
@export var weapon_cost : int = 10000
@export var ammo_cost : int = 500


var m_current_clip_size : int
var m_barrel : Node3D


func init() -> void:

	m_current_clip_size = clip_size


func has_ammo() -> bool:
	return m_current_clip_size > 0 or clip_size < 0

func use_ammo() -> void:
	if clip_size < 0:
		return
	m_current_clip_size -= 1

func refill_ammo(amount: int) -> bool:
	if m_current_clip_size >= clip_size:
		return false

	m_current_clip_size += amount
	m_current_clip_size = max(m_current_clip_size, clip_size)
	return true

func instantiate_scene(scene_path : String) -> Node3D:
	var scene : PackedScene = ResourceLoader.load(scene_path)
	var ins = scene.instantiate() as Node3D
	return ins

func instantiate_weapon_model(anchor : Node3D) -> Node3D:
	var m = instantiate_scene(model)
	anchor.add_child(m)
	for child in m.get_children():
		if child.name.to_lower().contains("barrel"):
			m_barrel = child
			break
	return m

func get_barrel() -> Node3D:
	return m_barrel



# Virtual function
func fire(owner : Node3D) -> void:
	WeaponBehaviours.m_weapon_behaviours[fire_behaviour].call(self, owner)
	#var expression : Expression = Expression.new()
	#var error = expression.parse(fire_behaviour, ["owner"])
	#if error != OK:
		#push_error(expression.get_error_text())
	#expression.execute([owner], self)
