class_name Enemy extends Node2D

var wall_layer:TileMapLayer
var ground_layer:TileMapLayer

var cell_size:int = 64
var syncronizer:Syncronizer
var player:Player 



var next_move_direction:Vector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	syncronizer = get_tree().get_first_node_in_group("syncronizer")
	wall_layer = get_tree().get_first_node_in_group("wall_layer")
	ground_layer = get_tree().get_first_node_in_group("ground_layer")
	
	syncronizer.beat.connect(_on_syncronizer_beat)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_syncronizer_beat(_beat_time:float) -> void:
	var current_cell = ground_layer.local_to_map(global_position)
	var intended_direction = player.current_cell - current_cell
	
	if intended_direction.x != 0 && !is_next_position_wall(position + (Vector2(sign(intended_direction.x),0) * cell_size)):
		next_move_direction = Vector2(sign(intended_direction.x),0)
	elif intended_direction.y != 0 && !is_next_position_wall(position + (Vector2(0,sign(intended_direction.y)) * cell_size)):
		next_move_direction = Vector2(0,sign(intended_direction.y))
	else:
		next_move_direction = Vector2.ZERO
	pulsate()
	tween_position()

func tween_position() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, 'position', position + (next_move_direction * cell_size), syncronizer._bps / 2)

func pulsate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, 'scale', Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, 'scale', Vector2(1, 1), 0.1)

func is_next_position_wall(next_position:Vector2) -> bool:
	var grid_position:Vector2 = wall_layer.local_to_map(next_position)
	var cell_is_wall:Vector2 = wall_layer.get_cell_atlas_coords(grid_position)
	if cell_is_wall == Vector2.ZERO:
		return true
	
	return false
