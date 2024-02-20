extends Area3D


var once = false
func _on_body_entered(body):
	if !once:
		once = true
		$AnimationPlayer.play("stretch")
		GameState.stretch.emit()


