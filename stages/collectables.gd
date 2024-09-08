class_name Collectable_Container extends Node

signal all_colletables_collected()

var colletables:Array[Collectable]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		colletables.append(child)
		child.is_collected.connect(_on_collectable_collected.bind(child))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_collectable_collected(_colletable:Collectable) -> void:
	colletables.erase(_colletable)
	
	if colletables.is_empty():
		all_colletables_collected.emit()
