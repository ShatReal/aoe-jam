extends Node


onready var _dialogue := $UI/Dialogue
onready var _text := $UI/Dialogue/Text
onready var _text_timer := $UI/Dialogue/Timer


func _ready() -> void:
	for i in get_tree().get_nodes_in_group("interactable"):
		i.connect("show_dialogue", self, "_on_dialogue_triggered")
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and $UI/Dialogue.visible:
		if _text.percent_visible == 1.0:
			_dialogue.hide()
			$Player.can_move = true
		else:
			_text_timer.stop()
			_text.percent_visible = 1.0


func _on_pause_pressed() -> void:
	Pause.show_pause()


func _on_dialogue_triggered(dialogue: String) -> void:
	_dialogue.show()
	_text.bbcode_text = dialogue
	_text.visible_characters = 0
	_text_timer.start()


func _on_text_timer_timeout() -> void:
	_text.visible_characters += 1
	if not _text.percent_visible == 1.0:
		_text_timer.start()
