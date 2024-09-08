class_name Score extends Control

@onready var score_label: Label = $ScoreLabel

var game_board:Game_Board

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_board = get_tree().get_first_node_in_group("game_board")
	if !game_board:
		return
	game_board.score_changed.connect(_on_score_changed)

	score_label.text = 'Score: %s' % game_board.score

func _on_score_changed(new_score) -> void:
	score_label.text = 'Score: %s' % new_score
