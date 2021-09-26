extends Node


signal scene_changed(to)


func _on_lose() -> void:
	emit_signal("scene_changed", "res://scenes/cutscenes/bad_end.tscn")


func _on_win() -> void:
	emit_signal("scene_changed", "res://scenes/cutscenes/good_end.tscn")
