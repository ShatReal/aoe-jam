extends Control


signal scene_changed(to)

export(String, FILE, "*.tscn") var new_game: String


func _ready() -> void:
	if OS.get_name() == "HTML5":
		$Quit.hide()


func _on_start_pressed() -> void:
	emit_signal("scene_changed", new_game)


func _on_quit_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
