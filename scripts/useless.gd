extends Area3D

@export var desc = "read a book"
@export var dialogue = "hm, none of these seem interesting right now."

func interact():
	GameState.show_dialogue.emit(dialogue)
