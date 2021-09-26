extends Node

signal scene_changed(to)

func _on_ECG_scene_changed(to) -> void:
	emit_signal("scene_changed", to)
