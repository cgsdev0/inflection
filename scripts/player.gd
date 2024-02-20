extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 9.0

const ACCEL = 3.0
const DECEL = 8.0

var speed = 0.0
var last = Vector3.ZERO

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var inside = false

func disable_collider():
	self.set_collision_layer_value(1, false)

func enable_collider():
	self.set_collision_layer_value(1, false)
	$RemoteTransform3D.rotation = Vector3.ZERO
	
func activate_camera():
	$RemoteTransform3D.active = true
	
func _ready():
	floor_snap_length = 1.0
	floor_max_angle = 0.9 # 0.785398

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	activate_camera()

var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

func get_camera():
	return $RemoteTransform3D
	
func _input(event):
	# Receives mouse motion
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
		
func _update_mouselook():
	if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
		return
	if !$RemoteTransform3D.active:
		return
	_mouse_position *= GameState.sensitivity
	var yaw = _mouse_position.x
	var pitch = _mouse_position.y
	_mouse_position = Vector2(0, 0)
	
	# Prevents looking up/down too far
	_total_pitch += pitch
	_total_pitch = clamp(_total_pitch, -90.0, 90.0)

	rotate_y(deg_to_rad(-yaw))
	$RemoteTransform3D.rotation = Vector3.ZERO
	$RemoteTransform3D.rotate_object_local(Vector3(1,0,0), deg_to_rad(-_total_pitch))

	
func _process(delta):
	var desired = Vector3.ZERO
	_update_mouselook()
	if !$RemoteTransform3D.active:
		GameState.picked = null
		return
	pick_things()
		
	var fly_hack = OS.is_debug_build() && Input.is_key_pressed(KEY_SHIFT)
	
	# Add the gravity.
	if not is_on_floor()  && !fly_hack:
		velocity.y -= gravity * delta

	var speed_modifier = 0.8
	
	if fly_hack:
		speed_modifier = 10.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		speed = move_toward(speed, SPEED * speed_modifier, ACCEL * delta)
		velocity = direction * speed
		last = direction
	else:
		speed = move_toward(speed, 0, DECEL * delta)
		velocity = speed * last
		


	var space_state = get_world_3d().direct_space_state
	
	var prev = global_transform.origin
	move_and_slide()

func pick_things():
	if $RemoteTransform3D/RayCast3D.is_colliding():
		GameState.picked = $RemoteTransform3D/RayCast3D.get_collider()
		var p = GameState.picked.global_position
		var anchor = GameState.picked.get_node("Anchor")
		if anchor != null:
			p = anchor.global_position
		GameState.picked_loc = get_viewport().get_camera_3d().unproject_position(p)
	else:
		GameState.picked = null
	if Input.is_action_just_pressed("interact"):
		if GameState.picked && GameState.picked.has_method("interact"):
			GameState.picked.interact()
