extends Label


func _process(delta):
	if GameState.global_hint:
		text = GameState.global_hint
		show()
	else:
		hide()
