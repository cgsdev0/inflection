extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start_fade.connect(start_fade)
	
func start_fade(out):
	if out:
		$AnimationPlayer.play("fade_out")
	else:
		$AnimationPlayer.play("fade_in")
	await $AnimationPlayer.animation_finished
	GameState.fade_finished.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
