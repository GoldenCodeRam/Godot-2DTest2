extends Node2D

var grid: AStarGrid2D

const GRID_SIZE: int = 16

func global_position_to_grid_position(pos: Vector2) -> Vector2i:
	return (pos / GRID_SIZE).round()

func grid_position_to_global_position(pos: Vector2i) -> Vector2:
	return pos * GRID_SIZE

# Called when the node enters the scene tree for the first time.
func _ready():
	grid = AStarGrid2D.new()
	grid.region = Rect2i(0, 0, 64, 64)
	grid.cell_size = Vector2(GRID_SIZE, GRID_SIZE)
	grid.update()



func _draw():
	draw_rect(Rect2(-8, -8, grid.region.end.x * GRID_SIZE, grid.region.end.y * GRID_SIZE), Color.RED, false)

	var previous_point = null
	for line in grid.get_point_path(Vector2i(0, 0), Vector2i(3, 4)):
		draw_rect(Rect2(line.x - 8, line.y -8, GRID_SIZE, GRID_SIZE), Color.WHITE, false)
		if previous_point == null:
			previous_point = line
			continue

		draw_line(previous_point, line, Color.WHITE)
		previous_point = line
