extends ProgressBar


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var progress = Globals.CONNECT4.get_progress()

	set_value_no_signal(progress)
