class_name Arrows extends Control

@export var player:Player
@export var syncronizer:Syncronizer

@export var arrow_left:TextureRect
@export var arrow_right:TextureRect
@export var arrow_up:TextureRect
@export var arrow_down:TextureRect

var current_arrow:TextureRect

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	syncronizer = get_tree().get_first_node_in_group("syncronizer")
	
	player.movement_direction_changed.connect(_on_player_movement_direction_changed)
	syncronizer.beat.connect(_on_syncronizer_beat)
	
	_hide_all_arrows()
	_on_player_movement_direction_changed(player.movement_direction)
	
func _hide_all_arrows() -> void:
	arrow_left.hide()
	arrow_right.hide()
	arrow_up.hide()
	arrow_down.hide()
	
func _on_player_movement_direction_changed(new_direction:Vector2) -> void:	
	_hide_all_arrows()
	if new_direction == Vector2.LEFT:
		arrow_left.show()
		current_arrow = arrow_left
	if new_direction == Vector2.RIGHT:
		arrow_right.show()
		current_arrow = arrow_right
	if new_direction == Vector2.UP:
		arrow_up.show()
		current_arrow = arrow_up
	if new_direction == Vector2.DOWN:
		arrow_down.show()
		current_arrow = arrow_down
		
func _on_syncronizer_beat(_beat_time) -> void:
	pulsate()
	
func pulsate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(current_arrow, 'scale', Vector2(1.1, 1.1), 0.1)
	tween.tween_property(current_arrow, 'scale', Vector2(1, 1), 0.1)
