extends CheckButton

func _process(delta):
	Globals.CONNECT4.edit_color = "yellow" if button_pressed else "red"
	text = Globals.CONNECT4.edit_color
