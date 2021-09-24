extends CanvasLayer


signal scene_changed(to)

const _SAVE_DIR := "user://saves/"
const _SAVE_ENDING := ".cfg"
const _SAVE_TEXT := "%02d/%02d/%02d %02d:%02d:%02d"

var save_info = {}

var _save_paths = []
var _cur_save:int = -1
var _save_num := 0
var _delete_all := false

onready var _slots := $SlotsPop/Scroll/VBox/Slots


func _ready() -> void:
	$Error.get_child(1).align = Label.ALIGN_CENTER
	$DeleteConfirm.get_child(1).align = Label.ALIGN_CENTER
	
	# Iterate through save directory and get all valid save files
	var dir := Directory.new()
	if not dir.dir_exists(_SAVE_DIR):
		dir.make_dir(_SAVE_DIR)
	dir.open(_SAVE_DIR)
	dir.list_dir_begin(true, true)
	var file_name := dir.get_next()
	while file_name:
		if not dir.current_is_dir() and file_name.ends_with(_SAVE_ENDING):
			if _check_save_valid(_SAVE_DIR + file_name):
				_save_paths.append(file_name)
				if int(file_name) > _save_num:
					_save_num = int(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	# Sort saves
	var config := ConfigFile.new()
	var times := []
	for i in _save_paths.size():
		config.load(_SAVE_DIR + _save_paths[i])
		var time:int = config.get_value("metadata", "unix")
		times.append([time, i])
	times.sort_custom(self, "_sort_save_times")
	for i in times.size():
		var temp = _save_paths[i]
		_save_paths[i] = _save_paths[times[i][1]]
		_save_paths[times[i][1]] = temp
	for path in _save_paths:
		var text := _get_save_text(_SAVE_DIR + path)
		if text:
			_make_save_slot(text, false)


func show_save_load(save_disabled := false) -> void:
	$Options/VBox/Save.disabled = save_disabled
	$SlotsPop/Scroll/VBox/HBox/NewSlot.disabled = save_disabled
	$SlotsPop.popup_centered()
	

func _check_save_valid(path: String) -> bool:
	var config := ConfigFile.new()
	if not config.load(path) == OK:
		return false
	if not config.has_section_key("metadata", "unix"):
		return false
	if not config.has_section_key("metadata", "datetime"):
		return false
	if not config.has_section_key("info", "save"):
		return false
	return true


func _sort_save_times(a:Array, b:Array) -> bool:
	return a[0] > b[0]


func _get_save_text(path: String) -> String:
	var config := ConfigFile.new()
	if not config.load(path) == OK:
		return ""
	var date: Dictionary = config.get_value("metadata", "datetime")
	return _SAVE_TEXT % [date.year, date.month, date.day, date.hour, date.minute, date.second]
	

func _make_save_slot(text: String, send_to_front: bool) -> void:
	var b := Button.new()
	b.text = text
	_slots.add_child(b)
	b.connect("pressed", self, "_on_save_slot_pressed", [b])
	if send_to_front:
		_slots.move_child(b, 0)
	

func _on_save_slot_pressed(b: Button) -> void:
	$Options.popup_centered()
	_cur_save = b.get_index()
	
	
func _on_save_pressed() -> void:
	_save(_SAVE_DIR + _save_paths[_cur_save], false)
	

func _save(path: String, make_new_slot: bool) -> void:
	var dir := Directory.new()
	if not dir.dir_exists(_SAVE_DIR):
		dir.make_dir(_SAVE_DIR)
	var config := ConfigFile.new()
	config.set_value("metadata", "unix", OS.get_unix_time())
	config.set_value("metadata", "datetime", OS.get_datetime())
	config.set_value("info", "save", save_info)
	
	if config.save(path) == OK:
		var date := OS.get_datetime()
		var text := _SAVE_TEXT % [date.year, date.month, date.day, date.hour, date.minute, date.second]
		
		if make_new_slot:
			_make_save_slot(text, true)
			_save_paths.push_front(path.replace(_SAVE_DIR, ""))
		else:
			var slot := _slots.get_child(_cur_save)
			slot.text = text
			_slots.move_child(slot, 0)
			var temp: String = _save_paths[_cur_save]
			_save_paths.remove(_cur_save)
			_save_paths.push_front(temp)
		$Options.hide()
	else:
		$Error.dialog_text = "Error saving file."
		$Error.popup_centered()


func _on_load_pressed() -> void:
	var config := ConfigFile.new()
	if config.load(_SAVE_DIR + _save_paths[_cur_save]) == OK:
		save_info = config.get_value("info", "save")
		$Options.hide()
	else:
		$Error.dialog_text = "Error loading file."
		$Error.popup_centered()


func _on_delete_pressed() -> void:
	$DeleteConfirm.popup_centered()
	_delete_all = false
	

func _on_delete_confirm_confirmed() -> void:
	if _delete_all:
		_delete_all_saves()
	else:
		$Options.hide()
		_delete_save()


func _delete_save() -> void:
	var dir := Directory.new()
	if dir.remove(_SAVE_DIR + _save_paths[_cur_save]) == OK:
		_save_paths.remove(_cur_save)
		_slots.get_child(_cur_save).queue_free()
		_cur_save = -1
	else:
		$Error.dialog_text = "Error deleting file."
		$Error.popup_centered()


func _on_new_slot_pressed() -> void:
	_save(_SAVE_DIR + ("%04d" + _SAVE_ENDING) % _save_num, true)
	_save_num += 1


func _on_delete_all_pressed() -> void:
	$DeleteConfirm.popup_centered()
	_delete_all = true


func _delete_all_saves() -> void:
	var dir := Directory.new()
	if not dir.dir_exists(_SAVE_DIR):
		return
	dir.open(_SAVE_DIR)
	dir.list_dir_begin(false, false)
	var file_name := dir.get_next()
	while file_name:
		if not dir.current_is_dir() and file_name.ends_with(_SAVE_ENDING):
			dir.remove(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	
	for slot in _slots.get_children():
		slot.queue_free()
	_cur_save = -1
