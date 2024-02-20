extends Node3D


var desc = "take a shower"
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact():
	if !GameState.panic_attack:
		panic_attack()
		return
	$CameraController.active = true
	$Water.emitting = true
	$Steam.emitting = true
	await get_tree().create_timer(2.5).timeout
	if GameState.called && !GameState.showered:
		GameState.show_dialogue.emit("i'll miss you, dad.")
	else:
		GameState.show_dialogue.emit([
			"this is a good way to start my day.<break>good job, me.",
			"i just can't believe he's gone.",
			"relax. you've got this.",
			"...",
			"focus on your breathing.<break>1<break>2<break>3<break>4"
			].pick_random())
	await GameState.dialogue_finished
	await get_tree().create_timer(1.5).timeout
	GameState.showered = true
	$CameraController.previous_camera()
	$Water.emitting = false
	$Steam.emitting = false

func panic_attack():
	$CameraController.active = true
	$Water.emitting = true
	$Steam.emitting = true
	await get_tree().create_timer(1.5).timeout
	GameState.show_dialogue.emit("this is a good way to start my day.<break>good job, me.")
	await GameState.dialogue_finished
	await get_tree().create_timer(1.0).timeout
	$CameraController2.active = true
	await get_tree().create_timer(1.5).timeout
	GameState.show_dialogue.emit("running kinda low on shampoo...")
	await GameState.dialogue_finished
	$CameraController.active = true
	await get_tree().create_timer(4.0).timeout
	# TODO: heartbeat sound
	await get_tree().create_timer(2.0).timeout
	GameState.show_dialogue.emit("why is my heart beating so fast?<break>oh no...<break>please, i was going to get so much done today...")
	await GameState.dialogue_finished
	# TODO: speed up heart beat
	GameState.quicktime.emit("PANIC", 10.0)
	var result = await GameState.quicktime_finish
	GameState.show_dialogue.emit("fuck<break>fuck<break>fuck<break>fuck<break>FUCK<break>...<break>...<break>breathe.")
	await GameState.dialogue_finished
	# TODO: slower heart beat
	await get_tree().create_timer(1.5).timeout
	if GameState.called:
		GameState.show_dialogue.emit("...i think i'm about to faint.")
	else:
		GameState.show_dialogue.emit("i think that's enough for today.")
	await GameState.dialogue_finished
	GameState.start_fade.emit(true)
	await GameState.fade_finished
	$Water.emitting = false
	$Steam.emitting = false
	get_tree().get_first_node_in_group("player").warp()
	GameState.panic_attack = true
	GameState.bedge_reset.emit()
