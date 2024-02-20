extends Area3D


var desc = "pick up phone"

func _ready():
	GameState.put_phone_down.connect(phone_down)
	
@onready var original_transform = global_transform
func phone_down():
	GameState.holding_phone = false
	lerpFrom = global_transform
	lerp_timer = 0.0
	call_deferred("move_down")

func move_down():
	GameState.jebaited = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func interact():
	if GameState.holding_phone:
		return
	GameState.holding_phone = true
	GameState.pickup_phone.emit()

var lerp_timer = 1.0
var lerpFrom

func _process(delta):
	if !GameState.stretched:
		return
	if GameState.holding_phone:
		return
	lerp_timer += delta * 1.6
	if lerp_timer < 1.0:
		%Phone.global_transform.origin = lerp(lerpFrom.origin, original_transform.origin, ease(lerp_timer, 0.5))
		%Phone.global_transform.basis = Basis(lerpFrom.basis.get_rotation_quaternion().slerp(original_transform.basis.get_rotation_quaternion(), ease(lerp_timer, 0.5)))
	else:
		%Phone.global_transform = original_transform
