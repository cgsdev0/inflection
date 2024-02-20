extends Node

var sensitivity = 0.1

var picked
var picked_loc
var global_hint = ""

var stretched = false

var in_dialogue = false

signal quicktime(label, difficulty)
signal quicktime_finish(result)

signal start_fade(out)
signal fade_finished

signal show_dialogue(t)
signal dialogue_finished

signal stretch
signal bedge_reset
