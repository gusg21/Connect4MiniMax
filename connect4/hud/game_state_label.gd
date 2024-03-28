extends Label

func _process(delta):
	if Globals.CONNECT4 == null:
		return
	
	text = str(Globals.CONNECT4.current_turn)
	modulate = Color.RED if Globals.CONNECT4.current_turn == "player" else Color.YELLOW
