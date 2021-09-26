extends PathFollow2D

export(NodePath) var bgline_path
export(int) var scaling = 100
var bgline = null
onready var beat1 = get_node("../../Beat1")
onready var beat2 = get_node("../../Beat2")
var beat1played = false
var beat2played = false
export(bool) var play = false
var pressed = false

# Taken from: https://sci-hub.se/10.1109/ECTICon.2014.6839844
var ecg_data = [48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 50, 52, 54,
				56, 58, 60, 62, 64, 65, 65, 66, 66, 65, 65, 63, 62, 61, 59, 58, 56, 55,
				54, 53, 52, 52, 51, 51, 50, 50, 49, 49, 49, 49, 49, 49, 48, 48, 49, 49,
				#qrs begin
				48, 48, 46, 42, 38, 34, 31, 29, 27, 28, 31, 37, 48, 65, 88, 108, 135, 
				146, 152, 154, 145, 137, 128, 117, 107, 96, 84, 70, 54, 34, 25, 22, 
				22, 24, 26, 30, 33, 36, 38, 40, 42, 43, 44, 45, 46, 46, 47, 47, 47, 47, 
				47, 48, 48, 48,
				#qrs end
				48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 50, 51, 52, 53, 55, 57, 
				59, 62, 64, 66, 68, 71, 73, 75, 77, 78, 80, 81, 83, 84, 84, 84, 83, 81, 
				78, 75, 72, 69, 65, 63, 60, 58, 55, 53, 52, 51, 51, 50, 50, 50, 49, 49, 
				49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49]
				
var normalized_ecg_data = []

var rescaled_ecg_data = []

var curve = Curve2D.new()
onready var path = get_node("..")

var current = 0
export(int, 20, 180) var bpm = 64
export(float, 0, 2.0) var progress = 0.3

func _ready():
	var max_val = ecg_data.max()
	var min_val = ecg_data.min()
	for point in ecg_data:
		normalized_ecg_data.append((float(point)-min_val)/(max_val-min_val))

	var size = get_viewport().size

	var x = 0
	for point in len(normalized_ecg_data)+1:
		curve.add_point(Vector2(size.x/len(normalized_ecg_data)*x, size.y/3+(normalized_ecg_data[point%len(normalized_ecg_data)]*-scaling)))
		x = x + 1
		
	rescaled_ecg_data = [] + normalized_ecg_data

	path.curve = curve
	bgline = get_node(bgline_path)
	bgline.points = curve.get_baked_points()
	
func rescale_ecg_data():
	var begin = 54
	var end = 108
	for index in range(begin, end):
		rescaled_ecg_data[index] = normalized_ecg_data[index] * progress

func _process(delta):		
	rescale_ecg_data()
	curve.clear_points()
	var size = get_viewport().size
	var x = 0
	for point in len(rescaled_ecg_data)+1:
		curve.add_point(Vector2(size.x/len(rescaled_ecg_data)*x, size.y/3+(rescaled_ecg_data[point%len(rescaled_ecg_data)]*-scaling)))
		x = x + 1
	path.curve = curve
	bgline = get_node(bgline_path)
	bgline.points = curve.get_baked_points()

func _input(event):
	if not play:
		return
		
	if pressed:
		return
		
	if event.is_action_pressed("interact"):
		if unit_offset >= 0.28 and unit_offset <= 0.38:
			progress = progress + 0.1
		else:
			progress = progress - 0.1
		pressed = true

func _physics_process(delta):
	unit_offset += bpm/60.0 * delta #1.0 * delta
	
	if unit_offset <= 0.10:
		beat1played = false
		beat2played = false
		pressed = false
	
	if unit_offset >= 0.25 and unit_offset <= 0.31:
		if not beat1played and play:
			beat1.play()
			beat1played = true
		
	if unit_offset >= 0.57 and unit_offset <= 0.63:
		if not beat2played and play:
			beat2.play()
			beat2played = true
			
	if unit_offset >= 0.90 and not pressed:
		progress = progress - 0.1
	pass
