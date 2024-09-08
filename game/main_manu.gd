class_name Main_Menu extends Control

signal start_game()

@onready var start: Button = $Start

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start.pressed.connect(_on_start_pressed)


func _on_start_pressed() -> void:
	start_game.emit()
