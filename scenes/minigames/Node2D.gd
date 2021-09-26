extends KinematicBody2D

var charge = 0.0
var gravity = Vector2(0.0, -9.81)
var velocity = Vector2(0.0, 0.0)

func set_follow(follow: PathFollow2D):
	print("yo")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("interact"):
		print("jump")
		jump()

func jump():
	if velocity.y >= 0.0:
		velocity.y = -50
	#if is_equal_approx(charge, 0.0):
	#	charge = PI
	#	print("okay")
	#pass

func _physics_process(delta):
	#velocity += Vector2.DOWN * gravity * delta
	#position += velocity * delta
	
	if position.y >= 0.0:
		position.y = 0
