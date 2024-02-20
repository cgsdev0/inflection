extends Node3D

@export var enabled = false
@export var controls: Light3D
@export var description = "the"
@export var descA = "turn on %s light"
@export var descB = "turn off %s light"

@onready var desc = descA

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	
func update():
	if controls:
		controls.visible = enabled
	$switch3.visible = enabled
	$switch2.visible = !enabled
	if enabled:
		$Anchor.position = $AnchorB.position
		desc = descB % description
	else:
		$Anchor.position = $AnchorA.position
		desc = descA % description
			
func interact():
	enabled = !enabled
	update()
