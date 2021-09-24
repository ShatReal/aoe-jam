extends Node


func _ready() -> void:
	for i in get_tree().get_nodes_in_group("interactable"):
		i.connect("show_dialogue", self, "_on_dialogue_triggered")
		

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and $UI/Dialogue.visible:
		$UI/Dialogue.hide()
		$Player.can_move = true


func _on_pause_pressed() -> void:
	Pause.show_pause()


func _on_dialogue_triggered(dialogue: String) -> void:
	$UI/Dialogue.show()
	$UI/Dialogue/Text.bbcode_text = dialogue
