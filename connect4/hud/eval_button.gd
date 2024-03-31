extends Button

func _pressed():
	text = "Eval: " + str(Globals.AI_.eval(Globals.BOARD.get_board(), Globals.CONNECT4.edit_color, Globals.CONNECT4.edit_color == "red", 0))
