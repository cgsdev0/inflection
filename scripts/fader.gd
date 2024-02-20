extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.start_fade.connect(start_fade)
	GameState.game_end.connect(start_fade_white)
	GameState.show_credits.connect(show_credits)

func show_credits():
	$AnimationPlayer.play("show_credits")
	
func start_fade_white():
	$AnimationPlayer.play("fade_white")
	await $AnimationPlayer.animation_finished
	GameState.fade_finished.emit()
	
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
