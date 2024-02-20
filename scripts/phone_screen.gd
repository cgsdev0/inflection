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
			if %Number.text.length() >= 8:
				$Calling.show()
				await get_tree().create_timer(3.0).timeout
				if %Number.text == "555-0143" && !GameState.called:
					sequence()
					return
				else:
					hang_up()
					await get_tree().create_timer(1.0).timeout
					GameState.show_dialogue.emit("no one answered...")
		_:
			if %Number.text.length() >= 8:
				return
			if %Number.text.length() == 3:
				%Number.text += "-"
			%Number.text += child.text

func hang_up():
	GameState.sequencing = false
	$Calling.hide()
	%Number.text = ""
	%CallingLabel.text = "Calling..."

func soft_failure():
	hang_up()
	GameState.put_phone_down.emit()
	GameState.show_dialogue.emit("i can't do it.<break>i can't.<break>i can't.<break>goddammit.")
	
func sequence():
	GameState.sequencing = true
	GameState.show_dialogue.emit("shit fuck, it's ringing")
	await GameState.dialogue_finished
	GameState.quicktime.emit("stay calm.", 2.0)
	var result = await GameState.quicktime_finish
	if !result:
		soft_failure()
		return
	%CallingLabel.text = "Connected"
	await get_tree().create_timer(1.0).timeout
	GameState.show_dialogue.emit(":Hello?")
	await GameState.dialogue_finished
	GameState.quicktime.emit("stay calm.", 3.0)
	result = await GameState.quicktime_finish
	if !result:
		soft_failure()
		return
	var username
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME").capitalize()
	else:
		username = "Sam"
	GameState.show_dialogue.emit("hi. i'm calling about my father's funeral arrangements.<break>:One moment, please.<break>:Am I speaking with %s?<break>...<break>yes.<break>:Perfect! Everything is still on schedule.<break>:The services will start at 3 o' clock this afternoon.<break>...<break>...<break>okay.<break>...<break>:Is there anything else I can help you with?<break>no. thank you.<break>i'll be there." % username)
	await GameState.dialogue_finished
	GameState.called = true
	hang_up()
	GameState.put_phone_down.emit()
	await get_tree().create_timer(2.0).timeout
	GameState.show_dialogue.emit("i guess i should head out, then.<break>.............")
	await GameState.dialogue_finished
	GameState.sequencing = false
	
func _process(delta):
	%Number2.text = %Number.text


func _on_button_end_pressed():
	hang_up()
