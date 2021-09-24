extends StaticBody2D


signal show_dialogue(dialogue)

export(PoolStringArray) var dialogue: PoolStringArray


func interact() -> void:
	emit_signal("show_dialogue", dialogue)
