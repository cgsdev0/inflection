extends Area3D

var desc = "go outside"

func end_game():
	return
	
func interact():
	if GameState.stretched && GameState.panic_attack:
		if !GameState.showered:
			GameState.show_dialogue.emit([
				"i smell awful.",
				"i need a shower first.",
				"maybe later."
			].pick_random())
			return
		elif !GameState.called:
			GameState.show_dialogue.emit([
				"i need to make that phone call first."
			].pick_random())
			return
		else:
			end_game()
			return
	GameState.show_dialogue.emit([
		"hah. yeah, as if.",
		"maybe just a quick trip to the grocery store?<break>nah, i'll do that tomorrow.",
		"doesn't look like anything interesting is happening out there.", 
		"i literally can't.",
		"ain't gonna happen.",
		"urrgghghh... nope. not happening.",
		"i wish...",
		"i'd rather not die today, thanks.",
		"fuck that.",
		"i'll be safer in here.",
		"i need to get some things done first.",
		].pick_random())
