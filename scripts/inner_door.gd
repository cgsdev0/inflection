extends Area3D


var desc = "open door"
@export var main_door = false

var open = false

func _ready():
	GameState.stretch.connect(stretch)
	
func stretch():
	if main_door:
		main_door = false
		open = false
		$AnimationPlayer.stop()
		$AnimationPlayer.play("close")
		
func _process(delta):
	if !main_door && !GameState.stretched:
		desc = ""
		return
	desc = "open door"
	
func interact():
	if !main_door && !GameState.stretched:
		return
	if $AnimationPlayer.is_playing():
		return
	open = !open
	if open:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play("close")
