class_name Game extends Node2D

@onready var main_menu: Main_Menu = $CanvasLayer/MainManu
@onready var game_over: Game_Over = $CanvasLayer/GameOver

const GAME_BOARD_SCENE = preload("res://game_board/game_board.tscn")
var game_board:Game_Board
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_menu.start_game.connect(_on_start_game)

func _on_start_game() -> void:
	main_menu.hide()
	game_board = GAME_BOARD_SCENE.instantiate()
	add_child(game_board)
	
	game_board.game_finished.connect(_on_game_over)

func _on_game_over(score:int) -> void:
	game_board.game_finished.disconnect(_on_game_over)
	game_board.queue_free()
	
	game_over.show()
	game_over.back.connect(_on_back_pressed)
	game_over.score(score)
	
func _on_back_pressed() -> void:
	main_menu.show()
	game_over.back.disconnect(_on_back_pressed)
	game_over.hide()
