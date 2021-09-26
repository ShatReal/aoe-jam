extends Node2D


signal show_dialogue(dialogue)

export(PoolStringArray) var dialogue: PoolStringArray
export(String, FILE, "*.tscn") var minigame: String


func interact() -> void:
	emit_signal("show_dialogue", dialogue, minigame)
