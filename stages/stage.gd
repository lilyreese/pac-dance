class_name Stage extends Node2D
@onready var syncronizer: Syncronizer = $Syncronizer

signal stage_clear()
@export var auto_start:bool = false

@onready var collectables: Collectable_Container = $Collectables

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collectables.all_colletables_collected.connect(_on_collectables_collected)
	if auto_start:
		start_stage()
func _on_collectables_collected() -> void:
	stage_clear.emit()

func start_stage() -> void:
	syncronizer.start_stage()
