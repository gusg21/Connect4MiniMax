extends Node2D

class_name Board

const BOARD_WIDTH = 7
const BOARD_HEIGHT = 6

@export_category("Refs")
@export var slot_scene: PackedScene
@export var connect4: Connect4

@export_category("Props")
@export var grid_spacing: float

var board: Dictionary = {}
var slots: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.BOARD = self
	
	for x in range(BOARD_WIDTH):
		for y in range(BOARD_HEIGHT):
			var pos = Vector2(x, y)
			board[pos] = "none"
						
			var slot = slot_scene.instantiate() as Slot
			
			slot.position = Vector2(x - BOARD_WIDTH / 2, y - BOARD_HEIGHT / 2) * grid_spacing
			slot.call_deferred("set_state", board[pos])
			slot.call_deferred("set_board", self)
			slot.call_deferred("set_board_pos", pos)
			
			add_child(slot)
			slots[pos] = slot			

func can_place_at(row):
	return board[Vector2(row, 0)] == "none"

func place_at(row, color):
	var depth = BOARD_HEIGHT - 1
	while board[Vector2(row, depth)] != "none":
		depth -= 1
	board[Vector2(row, depth)] = color
	update_board()

func get_board():
	return board

func update_board():
	for x in range(BOARD_WIDTH):
		for y in range(BOARD_HEIGHT):
			var pos = Vector2(x, y)
			slots[pos].set_state(board[pos])
