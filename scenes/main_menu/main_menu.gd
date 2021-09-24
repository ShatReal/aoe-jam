extends Control


signal scene_changed(to)

export(String, FILE, "*.tscn") var new_game: String


func _ready() -> void:
	if OS.get_name() == "HTML5":
		$Quit.hide()


func _on_start_pressed() -> void:
	emit_signal("scene_changed", new_game)


func _on_continue_pressed() -> void:
	SaveLoad.show_save_load(true)


func _on_options_pressed() -> void:
	Options.show_options()


func _on_credits_pressed() -> void:
	$CreditsPop.popup_centered()


func _on_meta_clicked(meta) -> void:
	OS.shell_open(meta)


func _on_quit_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)
