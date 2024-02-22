extends TextureRect


var direction = 1
@export var difficulty = 1.0
var stopped = false

var stage = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	GameState.quicktime.connect(self.trigger)

func trigger(label, difficult):
	call_deferred("delayed_trigger", label, difficult)

func delayed_trigger(label, difficult):
	$Tick.play()
	difficulty = difficult
	stopped = false
	$Label.anchor_left = 0.0
	$Label.add_theme_color_override("font_color", Color.WHITE)
	$Description.text = label
	stage = 0
	show()

func resolve(result):
	if result:
		$Success.play()
	else:
		$Fail.play()
	await get_tree().create_timer(1.0).timeout
	hide()
	GameState.quicktime_finish.emit(result)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if stopped || !visible:
		return
	if Input.is_action_just_pressed("interact"):
		print($Label.anchor_left - 0.5)
		stopped = true
		if abs($Label.anchor_left - 0.5) < 0.048:
			$Label.add_theme_color_override("font_color", Color.GREEN)
			resolve(true)
			return
		else:
			$Label.add_theme_color_override("font_color", Color.RED)
			resolve(false)
			return

	$Label.anchor_left += delta * direction * difficulty * 0.5
	if $Label.anchor_left > 1.0:
		$Tick.play()
		$Label.anchor_left = 1.0
		direction = -1
		stage += 1
	if $Label.anchor_left < 0.0:
		$Tick.play()
		$Label.anchor_left = 0.0
		stage += 1
		
		direction = 1
	if stage == 2:
		$Label.add_theme_color_override("font_color", Color.YELLOW)
	elif stage == 3:
		$Label.add_theme_color_override("font_color", Color.RED)
	elif stage == 4:
		$Label.add_theme_color_override("font_color", Color.RED)
		stopped = true
		resolve(false)
