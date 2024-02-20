extends Area3D

var desc = "go to bed"

var rdy = false

func _ready():
	$CameraController.skip_a_lerp()
	$CameraController.active = true
	GameState.bedge_reset.connect(zzzzzz2)
	start_sequence()
	
func start_sequence():
	await get_tree().create_timer(2.0).timeout
	GameState.start_fade.emit(false)
	await GameState.fade_finished
	settled_in()
	
func settled_in():
	rdy = true
	GameState.global_hint = "press E to snooze alarm"
	
func _process(delta):
	if rdy && Input.is_action_just_pressed("skip") && OS.is_debug_build():
		rdy = false
		GameState.global_hint = ""
		get_tree().get_first_node_in_group("player").activate_camera()
		
	if rdy && Input.is_action_just_pressed("interact"):
		rdy = false
		GameState.global_hint = ""
		call_deferred("get_up")
		
func get_up():
	GameState.quicktime.emit("Get out of bed!", 1.0)
	var result = await GameState.quicktime_finish
	if result:
		wake_up()
	else:
		back_to_sleep()
		
func back_to_sleep():
	GameState.show_dialogue.emit([
		"maybe if i go back to sleep, i just won't wake up again.",
		"nevermind. goodnight, world.",
		"fuck this. i'm going back to sleep.", 
		"my heart is pounding like crazy. maybe i should sleep a bit more...",
		"it's honestly just not fair.",
		"...<break>it should have been me.",
		"one more snooze. then i'll start my day.",
		"urrgghghh... nope. not happening."
		].pick_random())
	await GameState.dialogue_finished
	zzzzzz()
	
func zzzzzz():
	$CameraController.active = true
	await get_tree().create_timer(1.0).timeout
	GameState.start_fade.emit(true)
	await GameState.fade_finished
	zzzzzz2()

func zzzzzz2():
	for node in get_tree().get_nodes_in_group("switches"):
		node.reset()
	if !GameState.called:
		GameState.showered = false
	$CameraController.active = true
	await get_tree().create_timer(2.0).timeout
	start_sequence()
	
func wake_up():
	$Awake.active = true
	await get_tree().create_timer(1.0).timeout
	GameState.show_dialogue.emit([
		"okay, i'm up. now i just need to get out of bed...",
		"what time is it even? what *day* is it?",
		"here we go again.",
		"i feel like shit. i should probably get up though..."
		].pick_random())
	await GameState.dialogue_finished
	GameState.quicktime.emit("Get out of bed!", randf_range(1.2, 1.9))
	var result = await GameState.quicktime_finish
	if result:
		get_tree().get_first_node_in_group("player").activate_camera()
		if !GameState.stretched:
			await get_tree().create_timer(1.0).timeout
			GameState.show_dialogue.emit([
			"pretty dark in here. i should turn on the lights."
			].pick_random())
	else:
		$CameraController.active = true
		back_to_sleep()
	
func interact():
	$CameraController.active = true
	await get_tree().create_timer(2.0).timeout
	GameState.show_dialogue.emit([
		"tomorrow. tomorrow i get back on track. maybe. whatever.",
		"i'm just not ready.",
		"i just need to hard reset my brain.",
		"...<break>g'night.",
		].pick_random())
	await GameState.dialogue_finished
	zzzzzz()
