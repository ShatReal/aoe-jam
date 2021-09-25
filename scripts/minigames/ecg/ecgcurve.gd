extends PathFollow2D

# Taken from: https://sci-hub.se/10.1109/ECTICon.2014.6839844
var ecg_data = [48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 50, 52, 54,
				56, 58, 60, 62, 64, 65, 65, 66, 66, 65, 65, 63, 62, 61, 59, 58, 56, 55,
				54, 53, 52, 52, 51, 51, 50, 50, 49, 49, 49, 49, 49, 49, 48, 48, 49, 49,
				48, 48, 46, 42, 38, 34, 31, 29, 27, 28, 31, 37, 48, 65, 88, 108, 135, 
				146, 152, 154, 145, 137, 128, 117, 107, 96, 84, 70, 54, 34, 25, 22, 
				22, 24, 26, 30, 33, 36, 38, 40, 42, 43, 44, 45, 46, 46, 47, 47, 47, 47, 
				47, 48, 48, 48,
				48, 48, 48, 48, 48, 48, 48, 49, 49, 49, 49, 49, 50, 51, 52, 53, 55, 57, 
				59, 62, 64, 66, 68, 71, 73, 75, 77, 78, 80, 81, 83, 84, 84, 84, 83, 81, 
				78, 75, 72, 69, 65, 63, 60, 58, 55, 53, 52, 51, 51, 50, 50, 50, 49, 49, 
				49, 49, 49, 49, 49, 49, 49, 49, 49, 49, 49]
				
var normalized_ecg_data = []

var curve = Curve2D.new()
onready var path = get_node("..")

var current = 0

func _ready():
	var max_val = ecg_data.max()
	for point in ecg_data:
		normalized_ecg_data.append(float(point)/max_val)

	var size = get_viewport().size

	var x = 0
	for point in len(normalized_ecg_data)+1:
		curve.add_point(Vector2(size.x/len(normalized_ecg_data)*x, (normalized_ecg_data[point%len(normalized_ecg_data)]*-50)))
		x = x + 1

	path.curve = curve

func _process(delta):
	unit_offset += 1.0 * delta

