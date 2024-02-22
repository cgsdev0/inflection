extends Area3D


var desc = "pick up phone"

func _ready():
	GameState.put_phone_down.connect(phone_down)
	$SubViewport/Control.dial_start.connect(dial_start)
	$SubViewport/Control.dial_end.connect(dial_end)
	$SubViewport/Control.play_a_tone.connect(play_a_tone)
	
func dial_start():
	$DialTone.play()
	
func dial_end():
	$DialTone.stop()
	
@onready var original_transform = global_transform
func phone_down():
	GameState.holding_phone = false
	lerpFrom = global_transform
	lerp_timer = 0.0
	call_deferred("move_down")

func move_down():
	$PhoneDown.play()
	GameState.jebaited = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func interact():
	if GameState.holding_phone:
		return
	$PhoneUp.play()
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

var playback # Will hold the AudioStreamGeneratorPlayback.
@onready var sample_hz = $AudioStreamPlayer.stream.mix_rate
var pulse_hz = 1209.0 # The frequency of the sound wave.
var pulse_hz2 = 697.0 # The frequency of the sound wave.

func play_a_tone(tone):
	match tone:
		"X", "1", "2", "3":
			pulse_hz = 697.0
		"4", "5", "6":
			pulse_hz = 770.0
		"7", "8", "9":
			pulse_hz = 852.0
		"0":
			pulse_hz = 941.0
	match tone:
		"1", "4", "7":
			pulse_hz2 = 1209.0
		"2", "5", "8", "0":
			pulse_hz2 = 1336.0
		"3", "6", "9":
			pulse_hz2 = 1477.0
		"X":
			pulse_hz2 = 1633.0
			
	$AudioStreamPlayer.play()
	playback = $AudioStreamPlayer.get_stream_playback()
	fill_buffer()

func fill_buffer():
	var phase = 0.0
	var phase2 = 0.0
	var increment = pulse_hz / sample_hz
	var increment2 = pulse_hz2 / sample_hz
	var frames_available = playback.get_frames_available()

	for i in range(frames_available):
		playback.push_frame(Vector2.ONE * sin(phase * TAU) + Vector2.ONE * sin(phase2 * TAU))
		phase = fmod(phase + increment, 1.0)
		phase2 = fmod(phase2 + increment2, 1.0)
