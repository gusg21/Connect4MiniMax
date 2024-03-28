extends Node

class_name Connect4

const AI_TURN_TIME = 5.0

var current_turn = "player"
var ai_timer: SceneTreeTimer

func _ready():
	Globals.CONNECT4 = self
	
	call_deferred("do_turn")

func get_progress():
	if ai_timer == null:
		return 0.0
	
	return (AI_TURN_TIME - ai_timer.time_left) / AI_TURN_TIME

func do_turn():
	if current_turn == "player":
		pass
	elif current_turn == "ai":
		Globals.AI_.start_thinking(Globals.BOARD.get_board(), "yellow")
		ai_timer = get_tree().create_timer(AI_TURN_TIME)
		ai_timer.connect("timeout", finish_turn)

func finish_turn():
	if current_turn == "ai":
		var ai_move = Globals.AI_.get_answer()
		print(ai_move)
		current_turn = "player"
	elif current_turn == "player":
		current_turn = "ai"
	
	do_turn()
