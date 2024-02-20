class_name MovementIndicatorComponent extends Node2D

var movement_indicators = []
var last_mouse_grid_position = null

func _ready():
	z_index = 1

func _process(_delta: float):
	# Only draw the path if the mouse has moved to another grid position
	if last_mouse_grid_position != GlobalAStarGrid.get_mouse_grid_position():
		last_mouse_grid_position = GlobalAStarGrid.get_mouse_grid_position()
	else:
		return

	var grid_position = GlobalAStarGrid.global_position_to_grid_position(global_position)
	var mouse_position = GlobalAStarGrid.get_mouse_grid_position()
	var path = GlobalAStarGrid.get_grid_path(grid_position, mouse_position)

	for i in range(movement_indicators.size()):
		movement_indicators.pop_at(0).queue_free()

	if !path.is_empty():
		for i in range(path.size() - 1):
			var indicator = Sprite2D.new()
			indicator.texture = load("res://assets/movement_indicator.png")
			indicator.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			indicator.global_position = GlobalAStarGrid.grid_position_to_global_position(
				path[i] - Vector2(grid_position.x, grid_position.y)
			)
			add_child(indicator)

			movement_indicators.append(indicator)

		var mouse_indicator = Sprite2D.new()
		mouse_indicator.texture = load("res://assets/interface/square_left_4.png")
		mouse_indicator.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		mouse_indicator.global_position = GlobalAStarGrid.grid_position_to_global_position(
			path[path.size() - 1] - Vector2(grid_position.x, grid_position.y)
		)
		add_child(mouse_indicator)

		movement_indicators.append(mouse_indicator)

func _draw():
	# var grid_position = GlobalAStarGrid.global_position_to_grid_position(global_position)
	# var path = GlobalAStarGrid.get_grid_path(
	# 	grid_position,
	# 	GlobalAStarGrid.get_mouse_grid_position()
	# )
	#
	# for n in range(1, path.size()):
	# 	draw_line(
	# 		(path[n - 1] - Vector2(grid_position.x, grid_position.y)) * GlobalAStarGrid.GRID_SIZE, 
	# 		(path[n] - Vector2(grid_position.x, grid_position.y)) * GlobalAStarGrid.GRID_SIZE, Color.CORAL
	# 	)
	pass
