extends Area3D


var desc = "open door"

var open = false

func interact():
	if $AnimationPlayer.is_playing():
		return
	open = !open
	if open:
		$AnimationPlayer.play("open")
	else:
		$AnimationPlayer.play("close")
