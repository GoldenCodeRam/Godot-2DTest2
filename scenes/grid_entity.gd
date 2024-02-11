class_name GridEntity extends Node

@onready var parent = get_parent()

var position: Vector2i:
	get:
		return position
	set(value):
		parent.position = value * GridManager.GRID_SIZE
		position = value

func _ready():
	position = Vector2i(2, 2)
