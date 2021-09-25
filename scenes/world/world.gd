extends Node


var _cur_line := -1
var _cur_dialogue: PoolStringArray

onready var _dialogue := $UI/Dialogue
onready var _text := $UI/Dialogue/Text
onready var _text_timer := $UI/Dialogue/Timer

func _ready() -> void:
	for i in get_tree().get_nodes_in_group("interactable"):
		i.connect("object_clicked", self, "_on_object_clicked")
		
func _on_object_clicked(object: Node2D) -> void:
	if "dialogue" in object and not object.dialogue.empty():
		_dialogue.show()
		_cur_dialogue = object.dialogue
		_cur_line = -1
		_advance_line()
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and $UI/Dialogue.visible:
		if _text.percent_visible == 1.0:
			if _cur_line == _cur_dialogue.size() - 1:
				_dialogue.hide()
				#$Player.can_move = true
			else:
				_advance_line()
		else:
			_text_timer.stop()
			_text.percent_visible = 1.0


func _on_pause_pressed() -> void:
	Pause.show_pause()


func _on_dialogue_triggered(dialogue: PoolStringArray) -> void:
	_dialogue.show()
	_cur_dialogue = dialogue
	_cur_line = -1
	_advance_line()
	
func _advance_line() -> void:
	_cur_line += 1
	_text.bbcode_text = _cur_dialogue[_cur_line]
	_text.visible_characters = 0
	_text_timer.start()


func _on_text_timer_timeout() -> void:
	_text.visible_characters += 1
	if not _text.percent_visible == 1.0:
		_text_timer.start()
