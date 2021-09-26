extends Node


const _SOUNDS_PATH := "res://sounds/%s"
const _MUSIC_PATH := "res://music/"

var _index := -1
var _waiting := false

onready var _wait := $Wait
onready var _sound := $Sound
onready var _music := $Music
onready var _title := $VBoxContainer/Title/Label
onready var _text := $VBoxContainer/Dialogue/Text
onready var _text_timer := $VBoxContainer/Dialogue/Text/TextTimer
onready var _ap := $AnimationPlayer


var _dialogue := PoolStringArray([
	"SOUND|doorbell.mp3",
	"Dr T|Hello Mrs. Moores, I'm Doctor Tania from your GP surgery. I'm here for your scheduled home visit?",
	"WAIT|3.0",
	"Dr T|That's strange. Jessica confirmed that she informed her that I'm coming. Let me try knocking.",
	"SOUND|door_knock.ogg",
	"SOUND|door_creak.ogg",
	"Dr T|Oh! The door is...open?",
	"ANIM|fade",
	"MUSIC|inside_the_house.ogg",
	"Dr T| Oh my god, Mrs Moores! It seems she tried to open the door to call for help, but fainted! Her pulse is fading, but she's still showing some signs of life.",
	"Dr T|It's a long shot, but let me try using the pulse reviver app on my phone. It's helped patients like this before, and I am running out of time!",
#	"ANIM phone",
])


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
