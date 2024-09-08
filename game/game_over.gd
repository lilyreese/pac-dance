class_name Game_Over extends Control

signal back

@onready var back_button: Button = $Back
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)

func score(new_score:int) -> void:
	label.text = 'Score: %s' % new_score
func _on_back_pressed() -> void:
	back.emit()
