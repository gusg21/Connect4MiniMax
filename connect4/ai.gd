extends Node2D

class_name AI

var thinking_thread: Thread

var mutex: Mutex = Mutex.new()
var best_answer: int = 0
var stop_requested: bool = false

func _ready():
	Globals.AI_ = self
	
	thinking_thread = Thread.new()

func start_thinking(board, side):
	stop_requested = false		
	thinking_thread.start(think.bind(board, side))

func try_get(board, pos):
	if pos.x < 0 or pos.x > 6 or \
		pos.y < 0 or pos.y > 5:
		return "none"
	return board[pos]

func has_win(board):
	for x in range(7):
		for y in range(6):
			var pos = Vector2(x, y)
			if board[pos] != "none":
				var side = board[pos]
				# up
				if try_get(board, pos+Vector2.UP) == side and \
					try_get(board, pos+Vector2.UP*2) == side and \
					try_get(board, pos+Vector2.UP*3) == side:
					return side
				
				# up-right
				if try_get(board, pos+Vector2.UP+Vector2.RIGHT) == side and \
					try_get(board, pos+Vector2.UP*2+Vector2.RIGHT*2) == side and \
					try_get(board, pos+Vector2.UP*3+Vector2.RIGHT*3) == side:
					return side
				
				# right
				if try_get(board, pos+Vector2.RIGHT) == side and \
					try_get(board, pos+Vector2.RIGHT*2) == side and \
					try_get(board, pos+Vector2.RIGHT*3) == side:
					return side
	
	return "none"

func print_board(board):
	for y in range(6):
		for x in range(7):
			if board[Vector2(x, y)] != "none":
				printraw(board[Vector2(x, y)][0])
			else:
				printraw(" ")
		printraw("\n")

func apply_move_to_board(board: Dictionary, move, color):
	var new_board = board.duplicate()
	var pos = Vector2(move, 5)
	while new_board[pos] != "none":
		pos += Vector2.UP
	new_board[pos] = color
	return new_board

func can_place_at(board: Dictionary, move):
	return board[Vector2(move, 0)] == "none"
	
func flip_side(side):
	if side == "yellow":
		return "red"
	if side == "red":
		return "yellow"
	
	printerr("Can't flip side %s" % [side])
	return "none"

func eval(board, side, worst, depth):
	var other_side = flip_side(side)	
	
	if has_win(board) == side:
		return [1000, -1]
	elif has_win(board) == other_side:
		return [-1000, -1]
	
	if depth >= Globals.CONNECT4.depth:
		return [0, -1]
	
	var best_move = -1
	var best_move_eval = INF if worst else -INF
	var moves = range(7)
	moves.shuffle()
	for move in moves:
		if can_place_at(board, move):
			var new_board = apply_move_to_board(board, move, other_side)
			var eval_ = eval(new_board, other_side, not worst, depth + 1)[0]
			print("%sm#%s: %s (as %s)" % ["\t".repeat(depth), move, eval_, other_side])
			if worst:
				if eval_ < best_move_eval:
					best_move_eval = eval_
					best_move = move
			else:
				if eval_ > best_move_eval:
					best_move_eval = eval_
					best_move = move
			#print_board(new_board)
			#print("eval: " + str(eval_))
	
	if depth == 0:
		print("--> %s (e %s)" % [best_move, best_move_eval])
	
	return [best_move_eval, best_move]
	
	## Would be so much better if i had a k/v pair iterator!! @godot!!
	#var best_opt = 0
	#var best_opt_val = INF
	#for option in options.keys():
		#if options[option] < best_opt_val:
			#best_opt_val = options[option]
			#best_opt = option
	#
	#return best_opt_val

func get_best_move(board, side):
	#var options = {}
	
	#for move in range(7):
		#if can_place_at(board, move):
			#var new_board = apply_move_to_board(board, move, side)
			#options[move] = eval(new_board, side, 1, 0)
	#
	## Would be so much better if i had a k/v pair iterator!! @godot!!
	#var best_opt = 0
	#var best_opt_val = -INF
	#for option in options.keys():
		#if options[option] > best_opt_val:
			#best_opt_val = options[option]
			#best_opt = option
	
	return eval(board, side, false, 0)[1]

func think(board, side):
	mutex.lock()
	best_answer = get_best_move(board, side)
	mutex.unlock()

func get_answer():
	var answer = 0
	mutex.lock()
	stop_requested = true
	thinking_thread.wait_to_finish()
	answer = best_answer
	mutex.unlock()
	return answer
