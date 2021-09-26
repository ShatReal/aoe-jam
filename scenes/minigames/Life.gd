extends VBoxContainer


signal lose


func _on_Timer_timeout() -> void:
	$ProgressBar.value -= 1
	if $ProgressBar.value <= 0:
		emit_signal("lose")
