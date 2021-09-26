extends Line2D

export (Gradient) var grad
export var speed := 1.0
export var precision := 1.0

var offset = 0.0

var last_points := [] #used to save the last x phyics_frame positions to use those with linear interp?
var follows := []

onready var path := get_node("../Path2D")
onready var collision := get_node("Node2D")
onready var normpath := get_node("../Path2D/PathFollow2D")

func _ready():
	for i in 10*precision:
		var new_follow = PathFollow2D.new()
		path.add_child(new_follow)
		new_follow.rotate = false
		new_follow.unit_offset = float(i*0.02/precision)
		follows.append(new_follow)
	
	#collision.set_follow(follows.front())
	remove_child(collision)
	follows.back().add_child(collision)

func _physics_process(delta):
	last_points.append(normpath.global_position)
	
	while len(last_points) > 10:
		last_points.pop_front()
	
	pass

func _process(delta):
	clear_points()
	#offset = wrapf(offset + delta * (60.0/speed), 0, 1)
	#var i = 0
	#for f in follows:
	#	f.unit_offset = offset + float(i*0.02/precision) #wrapf(f.unit_offset + delta * (60.0/speed), 0, 1)
	#	i = i + 1
	#	add_point(f.global_position)
	
	for point in last_points:
		add_point(point)
	
	gradient.colors[0] = grad.interpolate(0)
	gradient.colors[1] = grad.interpolate(1)
