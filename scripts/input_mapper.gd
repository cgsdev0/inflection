extends Control

	
const LEFT = 922.0 / 1436.0
const RIGHT = 1214.0 / 1436.0
const TOP = 417.0 / 1078.0
const BOTTOM = 950.0 / 1078.0
const W = RIGHT - LEFT
const H = BOTTOM - TOP
func _input(event):
	if event is InputEventMouse:
		var phone_screen = get_tree().get_first_node_in_group("phone")
		if !phone_screen:
			return
		if !GameState.holding_phone:
			return
		var x = event.position.x / $SubViewportContainer/SubViewport.size.x
		var y = event.position.y / $SubViewportContainer/SubViewport.size.y
		if x >= LEFT && x <= RIGHT && y >= TOP && y <= BOTTOM:
			event.position.x = (x - LEFT) / W * phone_screen.size.x
			event.position.y= (y - TOP) / H* phone_screen.size.y
			phone_screen.push_input(event, true)
		elif event is InputEventMouseButton && event.pressed && !GameState.sequencing:
			GameState.put_phone_down.emit()
