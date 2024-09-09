class_name Collectable extends Node2D

signal is_collected()

var syncronizer:Syncronizer
var already_collected = false

func _ready() -> void:
	syncronizer = get_tree().get_first_node_in_group("syncronizer")
	syncronizer.beat.connect(_on_syncronizer_beat)
	
func _on_syncronizer_beat(_beat_time:float) -> void:
	pulsate()
	
func pulsate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, 'scale', Vector2(1.1, 1.1), 0.15)
	tween.parallel().tween_property(self, 'rotation', 0.4, 0.1)
	tween.tween_property(self, 'scale', Vector2(1, 1), 0.2)
	tween.parallel().tween_property(self, 'rotation', 0, 0.1)
	
func collected() -> void:
	if(!already_collected):
		already_collected = true
		is_collected.emit()
		var tween:Tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_BOUNCE)
		tween.tween_property($Sprite2D, 'scale', Vector2(2, 2), 0.3)
		tween.parallel().tween_property($Sprite2D, 'position', Vector2(0, -16), 0.3)
		tween.parallel().tween_property($Sprite2D, 'modulate', Color.TRANSPARENT, 0.3)
		tween.tween_callback(queue_free)
	
