
extends Area3D


func undo_stretch():
	GameState.show_dialogue.emit([
		"oh man, i feel dizzy...<break>today just doesn't feel possible.<break>... shit.",
	].pick_random())
	await GameState.dialogue_finished
	GameState.start_fade.emit(true)
	await GameState.fade_finished
	%StretchStart/AnimationPlayer.play("RESET")
	get_tree().get_first_node_in_group("player").warp()
	GameState.stretched = true
	GameState.bedge_reset.emit()

var once = false
func _on_body_entered(body):
	if !once:
		once = true
		call_deferred("undo_stretch")
