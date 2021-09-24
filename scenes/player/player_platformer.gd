extends KinematicBody2D


const _MAX_SPEED := 200
const _FRICTION := 1000
const _ACCELERATION := 800
const _GRAVITY := 1000
const _JUMP_FORCE := 400

var _velocity := Vector2()

onready var _ray_cast := $RayCast2D


func _physics_process(delta: float) -> void:
	var input := Input.get_action_strength("right") - Input.get_action_strength("left")
	if input == 0.0:
		_velocity.x = move_toward(_velocity.x, 0, _FRICTION * delta)
	else:
		_velocity.x = move_toward(_velocity.x, input * _MAX_SPEED, _ACCELERATION * delta)
	_velocity.y += _GRAVITY * delta
	if _ray_cast.is_colliding() and Input.is_action_just_pressed("up"):
		_velocity.y -= _JUMP_FORCE
	_velocity = move_and_slide(_velocity)
