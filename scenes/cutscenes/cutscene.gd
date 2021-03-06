extends Node


signal scene_changed(to)

const _SOUNDS_PATH := "res://sounds/%s"
const _MUSIC_PATH := "res://music/%s"

export(PoolStringArray) var _dialogue: PoolStringArray

var _index := -1
var _waiting := false

onready var _wait := $Wait
onready var _sound := $Sound
onready var _music := $Music
onready var _title := $VBoxContainer/Title/Label
onready var _text := $VBoxContainer/Dialogue/Text
onready var _text_timer := $VBoxContainer/Dialogue/Text/TextTimer
onready var _ap := $AnimationPlayer


func _ready() -> void:
	_advance_dialogue()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not _waiting:
		if _text.percent_visible == 1.0:
			_advance_dialogue()
		else:
			_text.percent_visible = 1.0
			_text_timer.stop()


func _advance_dialogue() -> void:
	_index += 1
	if _index >= _dialogue.size():
		return
	var line = _dialogue[_index].split("|")
	match line[0]:
		"SET":
			match line[1]:
				"black":
					_ap.play("fade_in")
					_ap.seek(1.0, true)
				"clear":
					_ap.play("fade_out")
					_ap.seek(1.0, true)
				"doctor":
					_ap.play("doctor_walk")
					_ap.seek(1.0, true)
			_advance_dialogue()
		"SOUND":
			_waiting = true
			_sound.stream = load(_SOUNDS_PATH % line[1])
			_sound.play()
		"WAIT":
			_waiting = true
			_wait.wait_time = float(line[1])
			_wait.start()
		"ANIM":
			_waiting = true
			_ap.play(line[1])
		"MUSIC":
			_waiting = true
			_music.stream = load(_MUSIC_PATH % line[1])
			_music.play()
			_advance_dialogue()
		"CHANGE":
			emit_signal("scene_changed", line[1])
		"SHOW":
			get_node(line[1]).show()
		_:
			_waiting = false
			_title.text = line[0]
			_text.bbcode_text = line[1]
			_text.visible_characters = 0
			_text_timer.start()


func _on_sound_finished() -> void:
	_advance_dialogue()


func _on_wait_timeout() -> void:
	_advance_dialogue()


func _on_animation_finished(_anim_name: String) -> void:
	_advance_dialogue()


func _on_text_timer_timeout() -> void:
	_text.visible_characters += 1
	if not _text.percent_visible == 1.0:
		_text_timer.start()


func _on_replay_pressed() -> void:
	emit_signal("scene_changed", "res://scenes/minigames/viewport.tscn")
