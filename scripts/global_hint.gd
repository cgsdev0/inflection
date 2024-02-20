extends Label


func _process(delta):
	if GameState.global_hint && !GameState.in_dialogue:
		text = GameState.global_hint
		show()
	else:
		hide()
