class_name EntityGridComponent extends Component

var _parent: Node2D

func _init(parent: Node2D):
	_parent = parent

func set_position(position: Vector2i):
	_parent.global_position = GlobalAStarGrid.grid_position_to_global_position(
		position
	)

func get_position():
	return GlobalAStarGrid.global_position_to_grid_position(
		_parent.global_position
	)

func move_toward(position: Vector2, delta: float):
	_parent.global_position = _parent.global_position.move_toward(
		position,
		delta
	)
