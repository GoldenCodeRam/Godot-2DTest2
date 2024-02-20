class_name AStarGrid extends TileMap

const GRID_SIZE: int = 16

@onready var a_star := AStar2D.new()
@onready var used_cells := get_used_cells(0)

var mutex: Mutex = Mutex.new()

func is_mouse_position_walkable() -> bool:
	var mouse_position = get_mouse_grid_position()
	var cell_data := get_cell_tile_data(0, mouse_position)
	if cell_data != null:
		return cell_data.get_custom_data('walkable')

	# The cell does not exist. It's outside the TileMap.
	return false

func grid_position_to_global_position(point: Vector2i) -> Vector2:
	return point * GRID_SIZE

func global_position_to_grid_position(pos: Vector2) -> Vector2i:
	return (pos / GRID_SIZE).round()

func get_grid_path(start: Vector2i, end: Vector2i) -> PackedVector2Array:
	var path = a_star.get_point_path(id(start), id(end))

	if !path.is_empty():
		path.remove_at(0)

	return path

func get_path_to_mouse_position(start: Vector2i) -> PackedVector2Array:
	return get_grid_path(start, get_mouse_grid_position())

func get_mouse_grid_position() -> Vector2i:
	return global_position_to_grid_position(get_global_mouse_position())

func _ready():
	_add_points()
	_connect_points()

func _add_points():
	for cell in used_cells:
		a_star.add_point(id(cell), cell, 1.0)

func _connect_points():
	for cell in used_cells:
		var neighbors = [
			# RIGHT, LEFT, DOWN, UP
			Vector2i(1,0), 
			Vector2i(-1,0), 
			Vector2i(0,1), 
			Vector2i(0,-1),
			# RIGHT DOWN, LEFT DOWN, RIGHT UP, LEFT UP
			Vector2i(1,1), 
			Vector2i(-1,1), 
			Vector2i(1,-1), 
			Vector2i(-1,-1)
		]
		for neighbor in neighbors:
			var next_cell: Vector2i = cell + neighbor
			var next_cell_data := get_cell_tile_data(0, next_cell)

			if used_cells.has(next_cell) and next_cell_data.get_custom_data('walkable'):
				var cell_data := get_cell_tile_data(0, cell)
				if cell_data.get_custom_data('walkable'):
					a_star.connect_points(id(cell), id(next_cell), false)


func id(point: Vector2i):
	var a = 2 * point.x if point.x >= 0 else -2 * point.x - 1
	var b = 2 * point.y if point.y >= 0 else -2 * point.y - 1

	# Cantor Pairing Function
	return (a + b) * (a + b + 1) / 2 + b
