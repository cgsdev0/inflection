extends RichTextLabel


var lines = []
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.show_dialogue.connect(show_dialogue)
	hide()

var idx = 0

func show_next():
	hide()
	visible_characters = 0
	text = '"' + lines[idx] + '"'
	idx += 1
	show()
	
func show_dialogue(t):
	GameState.in_dialogue = true
	call_deferred("deferred", t)
	
func deferred(t):
	idx = 0
	text = ""
	visible_characters = 0
	lines = t.split("<break>")
	show_next()

func resolve():
	GameState.in_dialogue = false
	GameState.dialogue_finished.emit()
	
var tick = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !visible:
		return
	tick += delta
	if  Input.is_action_just_pressed("interact"):
		if visible_characters < get_total_character_count():
			visible_characters = get_total_character_count()
		else:
			if idx >= lines.size():
				hide()
				call_deferred("resolve")
			else:
				show_next()
	if visible_characters < get_total_character_count() && tick > 0.05:
		tick = 0
		visible_characters += 1
