extends Camera3D

var controller = null

# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.pickup_phone.connect(on_pickup)

var lerp_timer = 0.0
var lerpFrom
func on_pickup():
	lerpFrom = %Phone.global_transform
	lerp_timer = 0.0
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	if !GameState.holding_phone:
		return
	lerp_timer += delta * 1.6
	if lerp_timer < 1.0:
		%Phone.global_transform.origin = lerp(lerpFrom.origin, $PhoneAnchor.global_transform.origin, ease(lerp_timer, 0.5))
		%Phone.global_transform.basis = Basis(lerpFrom.basis.get_rotation_quaternion().slerp($PhoneAnchor.global_transform.basis.get_rotation_quaternion(), ease(lerp_timer, 0.5)))
	else:
		%Phone.global_transform = $PhoneAnchor.global_transform
