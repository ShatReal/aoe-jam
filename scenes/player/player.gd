extends KinematicBody2D


const _MAX_SPEED := 200
const _FRICTION := 1000
const _ACCELERATION := 800

var can_move := true
var _velocity := Vector2()


func _physics_process(delta: float) -> void:
	if can_move:
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


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and can_move:
		for area in $Detector.get_overlapping_areas():
			if area.get_parent().has_method("interact"):
				area.get_parent().interact()
				can_move = false
				get_tree().set_input_as_handled()
				break
