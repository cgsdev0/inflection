extends Label


func _process(delta):
	if GameState.picked && "desc" in GameState.picked && !GameState.in_dialogue && !GameState.holding_phone:
		text = GameState.picked.desc
		show()
		
		position = GameState.picked_loc
	else:
		hide()
