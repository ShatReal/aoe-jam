extends KinematicBody2D


const _MAX_SPEED := 200
const _FRICTION := 1000
const _ACCELERATION := 800

var _velocity := Vector2()


func _physics_process(delta: float) -> void:
	var input := Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		Input.get_action_strength("down") - Input.get_action_strength("up")
	)
	input = input.normalized()
	if input == Vector2.ZERO:
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	else:
		_velocity = _velocity.move_toward(input * _MAX_SPEED, _ACCELERATION * delta)
	_velocity = move_and_slide(_velocity)
