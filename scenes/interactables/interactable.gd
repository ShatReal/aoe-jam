extends StaticBody2D


signal show_dialogue(dialogue)

export(String, MULTILINE) var dialogue: String


func interact() -> void:
	emit_signal("show_dialogue", dialogue)
