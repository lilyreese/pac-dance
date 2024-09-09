extends Line2D

var offset : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_level = true
	offset = position

func _physics_process(_delta: float) -> void:
	global_position = Vector2.ZERO
	add_point(get_parent().global_position + offset, 0)
	if get_point_count() > 5:
		remove_point(get_point_count() - 1)
