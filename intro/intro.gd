extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Intro/AnimationPlayer.play("Fade ")
	await get_tree().create_timer(6).timeout
	$Intro/AnimationPlayer.play("FadeOut")
	await get_tree().create_timer(3).timeout
	get_tree().change_scene_to_file("res://game/game.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
