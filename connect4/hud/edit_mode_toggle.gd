extends CheckBox

func _process(delta):
	Globals.CONNECT4.edit_mode = button_pressed
	
