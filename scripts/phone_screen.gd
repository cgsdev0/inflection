extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$Calling.hide()
	for child in %Buttons.get_children():
		child.pressed.connect(Callable(on_press).bind(child))

func on_press(child):
	match child.text:
		"[X]":
			if %Number.text.length():
				%Number.text = %Number.text.left(%Number.text.length() - 1)
				if %Number.text.ends_with("-"):
					%Number.text = %Number.text.left(%Number.text.length() - 1)
		"Call":
			if %Number.text == "911" || %Number.text == "999":
				dial_start.emit()
				$Calling.show()
				emergency_sequence()
				return
			elif %Number.text.length() >= 8:
				dial_start.emit()
				$Calling.show()
				if %Number.text == "555-0143" && !GameState.called:
					sequence()
					return
				else:
					await get_tree().create_timer(6.5).timeout
					dial_end.emit()
					hang_up()
					GameState.show_dialogue.emit("no one answered...")
		_:
			if %Number.text.length() >= 8:
				return
			play_a_tone.emit(child.text)
			if %Number.text.length() == 3:
				%Number.text += "-"
			%Number.text += child.text

func hang_up():
	GameState.sequencing = false
	$Calling.hide()
	%Number.text = ""
	%CallingLabel.text = "Calling..."

func soft_failure(skip_text = false):
	hang_up()
	GameState.put_phone_down.emit()
	if !skip_text:
		GameState.show_dialogue.emit("i can't do it.<break>i can't.<break>goddammit.")

var easter_eggs = [
	":911, what is your emergency?",
	":911, I think we got disconnected. Are you okay?",
	":Look, stop prank calling us. You could get in a lot of trouble."
]
var easter_index = 0
func emergency_sequence():
	if easter_index >= easter_eggs.size():
		await get_tree().create_timer(6.5).timeout
		dial_end.emit()
		hang_up()
		GameState.show_dialogue.emit("no one answered...")
		return
	GameState.sequencing = true
	await get_tree().create_timer(4.0).timeout
	dial_end.emit()
	%CallingLabel.text = "Connected"
	await get_tree().create_timer(1.0).timeout
	GameState.show_dialogue.emit(easter_eggs[easter_index])
	easter_index += 1
	await GameState.dialogue_finished
	GameState.quicktime.emit("UHHHHH", 9.0)
	var result = await GameState.quicktime_finish
	soft_failure(true)
	await get_tree().create_timer(0.5).timeout
	GameState.show_dialogue.emit("...why did i just do that?")
	
func sequence():
	GameState.sequencing = true
	await get_tree().create_timer(2.0).timeout
	GameState.show_dialogue.emit("shit fuck, it's ringing")
	await GameState.dialogue_finished
	GameState.quicktime.emit("stay calm.", 1.4)
	var result = await GameState.quicktime_finish
	if !result:
		soft_failure()
		return
	dial_end.emit()
	%CallingLabel.text = "Connected"
	await get_tree().create_timer(1.0).timeout
	GameState.show_dialogue.emit(":Hello?")
	await GameState.dialogue_finished
	GameState.quicktime.emit("stay calm.", 1.9)
	result = await GameState.quicktime_finish
	if !result:
		soft_failure()
		return
	var username
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME").capitalize()
	else:
		username = "Sam"
	GameState.show_dialogue.emit("hi. i'm calling to schedule a doctor's appointment.<break>:One moment, please.<break>:Am I speaking with %s?<break>...<break>yes.<break>:We actually have an opening at 3 o' clock today.<break>:Does that work for you?" % username)
	await GameState.dialogue_finished
	GameState.quicktime.emit("say yes", 2.3)
	result = await GameState.quicktime_finish
	if !result:
		GameState.show_dialogue.emit("no. uhh, i need to go. bye.")
		await GameState.dialogue_finished
		soft_failure(true)
		return
	GameState.show_dialogue.emit("uhh okay, i guess i can do that<break>:Perfect! We'll see you then.")
	await GameState.dialogue_finished
	GameState.called = true
	hang_up()
	GameState.put_phone_down.emit()
	await get_tree().create_timer(2.0).timeout
	GameState.show_dialogue.emit("why did i say yes?<break>i guess i should head out, then.<break>.........")
	await GameState.dialogue_finished
	GameState.sequencing = false
	
func _process(delta):
	%Number2.text = %Number.text


func _on_button_end_pressed():
	pass
	# hang_up()
	
signal dial_start
signal dial_end
signal play_a_tone(tone)
