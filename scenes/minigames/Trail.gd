extends Line2D

export (Gradient) var grad
var last_points := []
onready var player := get_node("../KinematicBody2D2")
var running = false
var last_pos = Vector2.ZERO
var count = 1

func _ready():
	pass

func _physics_process(delta):
	if running:
		last_points.append(player.global_position)
		last_pos = player.global_position
		count = 1
	else:
		# move further to right to fake gong off-screen
		if not last_points.empty():
			last_points.append(last_pos + Vector2(player.speed * delta, 0.0) * count)
			count = count + 1
	
	while len(last_points) > 35:
		last_points.pop_front()
	
	pass

func clear_custom_points():
	last_points.clear()
	last_pos = Vector2.ONE

func _process(delta):
	clear_points()

	for point in last_points:
		add_point(point)
	
	gradient.colors[0] = grad.interpolate(0)
	gradient.colors[1] = grad.interpolate(1)
