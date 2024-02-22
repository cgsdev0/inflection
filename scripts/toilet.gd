extends Area3D

var desc = "use toilet"

var seated = false
# Called when the node enters the scene tree for the first time.
func interact():
	$CameraController.active = true
	seated = true


func get_up():
	$Flush.play()
	seated = false
	$CameraController.previous_camera()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("interact") && seated:
		call_deferred("get_up")

