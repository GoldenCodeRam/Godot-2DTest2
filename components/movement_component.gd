class_name MovementComponent extends Node2D

@onready var parent: Entity = get_parent()

enum Status {
	IDLE,
	MOVING,
}

signal _on_status_changed(status: Status)

var status: Status = Status.IDLE

var path_to_follow: Array = []
var current_target_grid_position = null
var current_target_global_position = null

var movement_indicator_component = null

func _ready():
	print("Init movement component")
	movement_indicator_component = MovementIndicatorComponent.new()
	add_child(movement_indicator_component)
	print(movement_indicator_component)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if status == Status.IDLE:
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

		# The movement component has reached its current target, and the path array
		# is empty. It has reached its destination.
		if path_to_follow.is_empty():
			status = Status.IDLE
			_on_status_changed.emit(status)

			movement_indicator_component = MovementIndicatorComponent.new()
			add_child(movement_indicator_component)

	# The movement component hasn't reached the current target, if it has one.
	if current_target_grid_position:
		status = Status.MOVING
		_on_status_changed.emit(status)

		if movement_indicator_component:
			movement_indicator_component.queue_free()
			movement_indicator_component = null

		parent.global_position = parent.global_position.move_toward(
			current_target_global_position,
			1
		)
	# The movement component has reached its current target, and its going to
	# select the next target in the path array.
	elif !path_to_follow.is_empty():
		current_target_grid_position = path_to_follow[0]
		current_target_global_position = GlobalAStarGrid.grid_position_to_global_position(current_target_grid_position)
		path_to_follow.remove_at(0)
