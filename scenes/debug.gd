class_name TileMapDebug extends Node2D

@onready var parent: AStarGrid = get_parent()

func _draw():
	for point in parent.used_cells:
		z_index = 2
		draw_rect(Rect2(point * 16, Vector2(16, 16)), Color.WHITE, false)

		if parent.get_cell_tile_data(0, point).get_custom_data('walkable'):
			draw_rect(Rect2(point * 16, Vector2(16, 16)), Color.GREEN, false)


	pass
