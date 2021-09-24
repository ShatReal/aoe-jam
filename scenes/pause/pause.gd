extends CanvasLayer


signal scene_changed(to)

export(String, FILE, "*.tscn") var _title_screen: String


func _ready() -> void:
	if OS.get_name() == "HTML5":
		$PausePop/VBoxContainer/Quit.hide()


func show_pause(can_save := true) -> void:
	get_tree().paused = true
	$PausePop/VBoxContainer/SaveLoad.visible = can_save
	$PausePop.popup_centered()


func _on_resume_pressed() -> void:
	$PausePop.hide()


func _on_save_load_pressed() -> void:
	SaveLoad.show_save_load()


func _on_options_pressed() -> void:
	Options.show_options()


func _on_title_pressed() -> void:
	emit_signal("scene_changed", _title_screen)
	$PausePop.hide()


func _on_quit_pressed() -> void:
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)


func _on_pause_pop_popup_hide() -> void:
	get_tree().paused = false
