extends Area3D

var desc = "sit down"

var seated = false
# Called when the node enters the scene tree for the first time.
func interact():
	$CameraController.active = true
	seated = true


func get_up():
	seated = false
	$CameraController.previous_camera()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && seated:
		call_deferred("get_up")

