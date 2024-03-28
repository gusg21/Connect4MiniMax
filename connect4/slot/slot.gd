extends Node2D

class_name Slot

var gfx: Sprite2D
var board: Board
var board_pos: Vector2
var player_color: String = "red"
var mouse_over: bool = false

func _ready():
	gfx = $GFX
	
	$Area2D.connect("mouse_entered", mouse_entered)
	$Area2D.connect("mouse_exited", mouse_exited)

func mouse_entered():
	mouse_over = true
	
func mouse_exited():
	mouse_over = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_over:
				on_clicked()

func on_clicked():
	if board.can_place_at(board_pos.x) and Globals.CONNECT4.current_turn == "player":
		if Globals.CONNECT4.edit_mode:
			board.place_at(board_pos.x, Globals.CONNECT4.edit_color)
		else:
			board.place_at(board_pos.x, player_color)
			Globals.CONNECT4.finish_turn()

func set_state(state: String):
	if state == "none":
		gfx.frame = 0
	if state == "red":
		gfx.frame = 1
	if state == "yellow":
		gfx.frame = 2

func set_board(_board: Board):
	board = _board

func set_board_pos(pos: Vector2):
	board_pos = pos
