extends KinematicBody2D


const _MAX_SPEED := 200
const _FRICTION := 1000
const _ACCELERATION := 800

var _velocity := Vector2()
var _dest


func _physics_process(delta: float) -> void:
	if _dest and _MAX_SPEED * delta > position.distance_to(_dest):
		_dest = null
	if _dest:
		var dir := position.direction_to(_dest)
		_velocity = _velocity.move_toward(dir * _MAX_SPEED, _ACCELERATION * delta)
	else:
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	_velocity = move_and_slide(_velocity)
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		_dest = get_global_mouse_position()
