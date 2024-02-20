extends RichTextLabel


var lines = []
# Called when the node enters the scene tree for the first time.
func _ready():
	GameState.show_dialogue.connect(show_dialogue)
	hide_both()

func hide_both():
	hide()
	%Operator.hide()
	
func show_both():
	show()
	%Operator.show()
	
var idx = 0
var alt = false
func show_next():
	hide_both()
	visible_characters = 0
	%Operator.visible_characters = 0
	if lines[idx].begins_with(":"):
		alt = true
		%Operator.text = '"' + lines[idx].substr(1) + '"'
	elif lines[idx].begins_with("?"):
		add_theme_color_override("default_color", Color.BLACK)
		z_index = 100
		alt = false
		text = '"' + lines[idx].substr(1) + '"'
	else:
		alt = false
		text = '"' + lines[idx] + '"'
	idx += 1
	show_both()
	
func show_dialogue(t):
	GameState.in_dialogue = true
	call_deferred("deferred", t)
	
func deferred(t):
	idx = 0
	text = ""
	%Operator.text = ""
	visible_characters = 0
	%Operator.visible_characters = 0
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
	var who
	if alt:
		who = %Operator
	else:
		who = self
	tick += delta
	if  Input.is_action_just_pressed("interact"):
		if who.visible_characters < who.get_total_character_count():
			who.visible_characters = who.get_total_character_count()
		else:
			if idx >= lines.size():
				hide_both()
				call_deferred("resolve")
				return
			else:
				show_next()
				return
	if who.visible_characters < who.get_total_character_count() && tick > 0.05:
		tick = 0
		who.visible_characters += 1
