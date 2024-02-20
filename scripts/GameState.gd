extends Node

var sensitivity = 0.1

var picked
var picked_loc
var global_hint = ""
var sequencing = false
var ended = false

var jebaited = false

var stretched = false
var panic_attack = false
var called = false
var showered = false
var in_dialogue = false
var holding_phone = false
func _process(delta):
	if !OS.is_debug_build():
		return
	if Input.is_action_just_pressed("skipstretch"):
		global_hint = "skipped stretch sequence"
		GameState.stretched = true
		await get_tree().create_timer(1.0).timeout
		global_hint = ""
		return
	if Input.is_action_just_pressed("skippanic"):
		global_hint = "skipped panic sequence"
		GameState.panic_attack = true
		await get_tree().create_timer(1.0).timeout
		global_hint = ""
		return
	if Input.is_action_just_pressed("skipshower"):
		global_hint = "showered = true"
		GameState.showered = true
		await get_tree().create_timer(1.0).timeout
		global_hint = ""
		return
	if Input.is_action_just_pressed("skipcall"):
		global_hint = "called = true"
		GameState.called = true
		await get_tree().create_timer(1.0).timeout
		global_hint = ""
		return
		
signal quicktime(label, difficulty)
signal quicktime_finish(result)

signal start_fade(out)
signal fade_finished

signal show_dialogue(t)
signal dialogue_finished

signal stretch
signal bedge_reset
signal pickup_phone
signal put_phone_down
signal game_end
signal show_credits
