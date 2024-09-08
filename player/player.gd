class_name Player extends Node2D

signal movement_direction_changed(new_direction)
signal game_over()
signal collected()

var syncronizer:Syncronizer
var wall_layer:TileMapLayer
var ground_layer:TileMapLayer
@export var sprite:Sprite2D

@export var hurtbox:Area2D

@onready var collect_area: Area2D = $CollectArea

var cell_size:float = 64

var current_cell:Vector2i

var movement_direction:Vector2 = Vector2.RIGHT:
	set = _set_movement_direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	syncronizer = get_tree().get_first_node_in_group("syncronizer")
	wall_layer = get_tree().get_first_node_in_group("wall_layer")
	ground_layer = get_tree().get_first_node_in_group("ground_layer")
	
	syncronizer.beat.connect(_on_syncronizer_beat)
	
	current_cell = ground_layer.local_to_map(global_position)
	
	hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	collect_area.area_entered.connect(_on_collect_area_entered)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_left"):
		if !is_next_position_wall(global_position + Vector2.LEFT * cell_size):
			movement_direction = Vector2.LEFT
	elif event.is_action_pressed("move_right"):
		if !is_next_position_wall(global_position + Vector2.RIGHT * cell_size):
			movement_direction = Vector2.RIGHT
	elif event.is_action_pressed("move_up"):
		if !is_next_position_wall(global_position + Vector2.UP * cell_size):
			movement_direction = Vector2.UP
	elif event.is_action_pressed("move_down"):
		if !is_next_position_wall(global_position + Vector2.DOWN * cell_size):
			movement_direction = Vector2.DOWN
	
func _on_syncronizer_beat(_beat_time:float) -> void:
	if is_next_position_wall(global_position + movement_direction * cell_size):
		movement_direction = -movement_direction
	tween_position()
	pulsate()
	
func is_next_position_wall(next_position:Vector2) -> bool:
	var grid_position:Vector2 = wall_layer.local_to_map(next_position)
	var cell_is_wall:Vector2 = wall_layer.get_cell_atlas_coords(grid_position)
	if cell_is_wall == Vector2.ZERO:
		return true
	
	return false
	
func tween_position() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, 'position', position + (movement_direction * cell_size), syncronizer._bps / 2)
	current_cell = ground_layer.local_to_map(global_position)
	
func pulsate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, 'scale', Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, 'scale', Vector2(1, 1), 0.1)

func _set_movement_direction(value:Vector2) -> void:
	movement_direction = value
	movement_direction_changed.emit(movement_direction)
	sprite.flip_h = movement_direction == Vector2.LEFT

func _on_hurtbox_area_entered(area:Area2D) -> void:
	game_over.emit()

func _on_collect_area_entered(area:Area2D) -> void:
	collected.emit()
	area.collected()
