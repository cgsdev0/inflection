extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var only = false

func _on_body_entered(body):
	if !only:
		only = true
		GameState.show_dialogue.emit("i really need to finish sorting through this stuff.<break>the memories are just too cruel...")
