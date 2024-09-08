class_name Collectable_Area extends Area2D


func pulsate() -> void:
	var tween:Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, 'scale', Vector2(1.1, 1.1), 0.1)
	tween.tween_property(self, 'scale', Vector2(1, 1), 0.1)
	
func collected()-> void:
	get_parent().collected()
