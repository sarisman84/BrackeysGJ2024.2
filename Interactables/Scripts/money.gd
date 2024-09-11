extends RigidBody3D

var value = 0
var fly_distance = 6
var jump_triggered = false

var fly_speed = 15
var jump_speed = 300

func _physics_process(_delta: float) -> void:
	if (Global.player_ref.position - position).length() < fly_distance:
		apply_central_force((Global.player_ref.position - position).normalized() * fly_speed)
		jump_once()

func jump_once() -> void:
	if jump_triggered:
		return
	if Global.player_ref.position.y > position.y:
		jump_triggered = true
		apply_central_force(Vector3(0, jump_speed, 0))

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		Global.current_currency = Global.current_currency + value
		queue_free()
