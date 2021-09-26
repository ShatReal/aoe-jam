extends KinematicBody2D

export (float) var speed = 520/(60.0/64.0)
export (int) var jump_speed = -1550
export (int) var gravity = 8500
var velocity = Vector2.ZERO
var max_height = 200
var jumping = false
var falling = false

var current = 0

onready var lines = [get_node("../LineA"), get_node("../LineB")]

func _ready():
	position.y = 135
	lines[current].running = true

func _physics_process(delta):
	# Play jump sound
	if jumping:
		if position.y >= 35:
			position.y -= speed * 1.44 * delta
		if position.y < 35:
			jumping = false
			falling = true
			
	if falling:
		if position.y < 135:
			position.y += speed * 1.44 * delta
		if position.y >= 135:
			falling = false
		
	velocity.x = speed
	#velocity.y += gravity * delta
	var temp_vel = min(velocity.y, speed*2)
	velocity = move_and_slide(Vector2(speed, temp_vel), Vector2.UP)
	if Input.is_action_just_pressed("interact"):
		if not falling:
			jumping = true
			#velocity.y = jump_speed

func _on_Timer_timeout():
	lines[current].running = false
	print("timer")
	#we reached 64bpm, reset player to 0.0
	position.x = -40.0
	current = 1 - current
	lines[current].clear_custom_points()
	#lines[current].clear_points()
	lines[current].running = true
	pass # Replace with function body.
