extends KinematicBody2D


const _ROT_SPEED := PI
const _MAX_SPEED := 200
const _FRICTION := 1000
const _ACCELERATION := 800

var _velocity := Vector2()


func _physics_process(delta: float) -> void:
	var rotation_input := Input.get_action_strength("right") - Input.get_action_strength("left")
	var movement_input := Input.get_action_strength("up") - Input.get_action_strength("down")
	rotation += rotation_input * _ROT_SPEED * delta
	if movement_input == 0.0:
		_velocity = _velocity.move_toward(Vector2.ZERO, _FRICTION * delta)
	else:
		_velocity = _velocity.move_toward(
			Vector2.RIGHT.rotated(rotation) * _MAX_SPEED * movement_input,
			_ACCELERATION * delta
		)
	_velocity = move_and_slide(_velocity)

