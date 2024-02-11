class_name MovementComponent extends Node2D

@onready var parent = get_parent()

var path_to_follow: Array = []
var current_target_grid_position = null
var current_target_global_position = null

var movement_indicator_component = null

func _ready():
	movement_indicator_component = MovementIndicatorComponent.new()
	add_child(movement_indicator_component)

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.is_pressed():
			movement_indicator_component.queue_free()
			movement_indicator_component = null

			path_to_follow = GlobalAStarGrid.get_grid_path(
				GlobalAStarGrid.global_position_to_grid_position(parent.global_position),
				GlobalAStarGrid.get_mouse_grid_position()
			)

func _physics_process(_delta: float):
	# Reached the current target
	# TODO: This assignment should not be done like this, as this can cause
	# side effects. The assignment of the global position should be something
	# authomatic, or at least managed by the own entity.
	if parent.global_position == current_target_global_position:
		parent.grid_position = current_target_grid_position
		current_target_grid_position = null
		current_target_global_position = null

		# If the path to follow is empty, let the movement indicator component
		# start again.
		if path_to_follow.is_empty():
			movement_indicator_component = MovementIndicatorComponent.new()
			add_child(movement_indicator_component)

	if current_target_grid_position:
		parent.test()

		parent.global_position = parent.global_position.move_toward(
			current_target_global_position,
			1
		)


	elif !path_to_follow.is_empty():
		current_target_grid_position = path_to_follow[0]
		current_target_global_position = GlobalAStarGrid.grid_position_to_global_position(current_target_grid_position)
		path_to_follow.remove_at(0)
