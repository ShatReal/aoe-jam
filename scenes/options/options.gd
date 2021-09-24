extends CanvasLayer


const _OPTIONS_DIR := "user://options/"
const _OPTIONS_FILE := "options.cfg"


func _ready() -> void:
	$Error.get_child(1).align = Label.ALIGN_CENTER
	
	if OS.get_name() == "HTMl5":
		$OptionsPop/Options/Vsync.hide()
	
	var dir := Directory.new()
	if not dir.dir_exists(_OPTIONS_DIR):
		dir.make_dir(_OPTIONS_DIR)
	var config := ConfigFile.new()
	if not config.load(_OPTIONS_DIR + _OPTIONS_FILE) == OK:
		return
	$OptionsPop/Options/Fullscreen.pressed = config.get_value("display", "fullscreen", false)
	OS.window_fullscreen = config.get_value("display", "fullscreen", false)
	$OptionsPop/Options/Borderless.pressed = config.get_value("display", "borderless", false)
	OS.window_borderless = config.get_value("display", "borderless", false)
	$OptionsPop/Options/Vsync.pressed = config.get_value("display", "vsync", false)
	OS.vsync_enabled = config.get_value("display", "vsync", false)
	$OptionsPop/Options/Mute.pressed = config.get_value("audio", "mute", false)
	AudioServer.set_bus_mute(0, config.get_value("audio", "mute", false))
	$OptionsPop/Options/MusicSlider.value = config.get_value("audio", "music", 0)
	AudioServer.set_bus_volume_db(1, config.get_value("audio", "music", 0))
	$OptionsPop/Options/SoundSlider.value = config.get_value("audio", "sound", 0)
	AudioServer.set_bus_volume_db(2, config.get_value("audio", "sound", 0))


func show_options() -> void:
	$OptionsPop.popup_centered()


func _save() -> void:
	var dir := Directory.new()
	if not dir.dir_exists(_OPTIONS_DIR):
		dir.make_dir(_OPTIONS_DIR)
	var config := ConfigFile.new()
	config.set_value("display", "fullscreen", $OptionsPop/Options/Fullscreen.pressed)
	config.set_value("display", "borderless", $OptionsPop/Options/Borderless.pressed)
	config.set_value("display", "vsync", $OptionsPop/Options/Vsync.pressed)
	config.set_value("audio", "mute", $OptionsPop/Options/Mute.pressed)
	config.set_value("audio", "music", $OptionsPop/Options/MusicSlider.value)
	config.set_value("audio", "sound", $OptionsPop/Options/SoundSlider.value)
	if not config.save(_OPTIONS_DIR + _OPTIONS_FILE) == OK:
		$Error.popup_centered()


func _on_fullscreen_toggled(button_pressed: bool) -> void:
	OS.window_fullscreen = button_pressed
	_save()


func _on_borderless_toggled(button_pressed: bool) -> void:
	OS.window_borderless = button_pressed
	_save()


func _on_vsync_toggled(button_pressed: bool) -> void:
	OS.vsync_enabled = button_pressed
	_save()


func _on_mute_toggled(button_pressed: bool) -> void:
	AudioServer.set_bus_mute(0, button_pressed)
	_save()


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, value)
	_save()


func _on_sound_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, value)
	_save()
