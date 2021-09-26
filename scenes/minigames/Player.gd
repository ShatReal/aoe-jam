extends KinematicBody2D

export (float) var speed = 1960/(60.0/64.0)
export (int) var jump_speed = -3350
export (int) var gravity = 15500
var velocity = Vector2.ZERO
var max_height = 200
var jumping = false
var falling = false

export (Gradient) var gradient1
export (Gradient) var gradient2

var gradients = []

onready var bgm = get_node("../../../BGM")

var current = 0
var current_gradient = 0
var tolerance = 0.1

onready var lines = [get_node("../../../LineA"), get_node("../../../LineB")]

func _ready():
	position.y = 1080.0/2.0
	lines[current].running = true
	lines[0].grad = gradient1
	lines[1].grad = gradient1
	gradients = [gradient1, gradient2]
	yield(get_tree().create_timer(0.08), "timeout")
	bgm.play()
	
func trigger_hit():
	print("Okay")
	current_gradient = 1 - current_gradient
	lines[0].grad = gradients[current_gradient]
	lines[1].grad = gradients[current_gradient]

func _input(event):
	if Input.is_action_just_pressed("interact") and is_on_floor():
		var timing = fmod(bgm.get_playback_position(), 60.0/128.0)
		if abs(timing - 60.0/128.0) <= tolerance:
			print("Okay")
			current_gradient = 1 - current_gradient
			lines[0].grad = gradients[current_gradient]
			lines[1].grad = gradients[current_gradient]

func _physics_process(delta):
	# Play jump sound
	if jumping:
		if position.y >= 150:
			position.y -= 6000 * 1.44 * delta
		if position.y <= 150:
			jumping = false
			falling = true
			
	if falling:
		if position.y < 540:
			position.y += 6000 * 1.44 * delta
		if position.y >= 540:
			falling = false
		
	velocity.x = 0 #speed
	velocity.y += gravity * delta
	var temp_vel = min(velocity.y, speed*2)
	#velocity = move_and_slide(Vector2(speed, temp_vel), Vector2.UP)
	
	if position.y >= 540:
		position.y = 540
	
	if Input.is_action_just_pressed("interact"):
		if not falling and not jumping:
			jumping = true
			#velocity.y = jump_speed

func _on_Timer_timeout():
	lines[current].running = false
	#we reached 64bpm, reset player to 0.0
	#position.x = -40.0
	current = 1 - current
	lines[current].clear_custom_points()
	#lines[current].clear_points()
	lines[current].running = true
	#print($"../".unit_offset)
	pass # Replace with function body.


func _on_Area2D_body_entered(body):
	trigger_hit()
	pass # Replace with function body.
