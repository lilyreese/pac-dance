class_name Game_Board extends Node2D

@onready var loading_screen: TextureRect = $CanvasLayer/Control/TextureRect

signal score_changed(new_score:int)
signal game_over()
signal game_finished()

const STAGE_1 = preload("res://stages/stage_1.tscn")
const STAGE_2 = preload("res://stages/stage_2.tscn")
const STAGE_3 = preload("res://stages/stage_3.tscn")
const STAGE_4 = preload("res://stages/stage_4.tscn")

var player:Player 
var score:int = 0
var score_at_stage_enter:int = 0

var current_stage:Stage
var current_stage_index:int = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_start_stage(current_stage_index)
	
func _on_player_game_over() -> void:
	_on_stage_clear(true)
	
func _on_player_collected() -> void:
	score += 1
	score_changed.emit(score)
	
func _start_stage(index:int) -> void:
	match index:
		1:
			current_stage = STAGE_1.instantiate()
			add_child(current_stage)
			if !current_stage.stage_clear.is_connected(_on_stage_clear):
				current_stage.stage_clear.connect(_on_stage_clear.bind(false))
		2:
			current_stage = STAGE_2.instantiate()
			add_child(current_stage)
			if !current_stage.stage_clear.is_connected(_on_stage_clear):
				current_stage.stage_clear.connect(_on_stage_clear.bind(false))
		3:
			current_stage = STAGE_3.instantiate()
			add_child(current_stage)
			if !current_stage.stage_clear.is_connected(_on_stage_clear):
				current_stage.stage_clear.connect(_on_stage_clear.bind(false))
		4:
			current_stage = STAGE_4.instantiate()
			add_child(current_stage)
			if !current_stage.stage_clear.is_connected(_on_stage_clear):
				current_stage.stage_clear.connect(_on_stage_clear.bind(false))
		_:
			game_finished.emit(score)			
	
	player = get_tree().get_first_node_in_group("player")
	if !player:
		return
	if !player.game_over.is_connected(_on_player_game_over):
		player.game_over.connect(_on_player_game_over)
	if !player.collected.is_connected(_on_player_collected):
		player.collected.connect(_on_player_collected)
	
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(loading_screen, 'position', Vector2(-1280, 0), 0.5)
	tween.tween_callback(current_stage.start_stage)
	
func _on_stage_clear(_same_stage:bool) -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(loading_screen, 'position', Vector2(0, 0), 0.5)
	
	current_stage.queue_free()
	await current_stage.tree_exited
	await get_tree().create_timer(0.5).timeout
	if !_same_stage:
		current_stage_index += 1
		score_at_stage_enter = score
	else:
		score = score_at_stage_enter
	_start_stage(current_stage_index)

	
