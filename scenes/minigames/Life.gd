extends VBoxContainer


signal lose
signal win


func _on_Timer_timeout() -> void:
	$ProgressBar.value -= 1
	if $ProgressBar.value <= 0:
		emit_signal("lose")
	elif $ProgressBar.value >= 100:
		emit_signal("win")
