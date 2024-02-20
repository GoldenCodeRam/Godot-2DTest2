class_name MovingMovementState extends MovementState

var _entity: Entity = null

var current_target_global_position = null
var current_target_grid_position = null

var path: PackedVector2Array = []
var path_indicators: Array[MovementIndicator] = []

func move() -> MovementState:
	# Reached the current target
	# TODO: This assignment should not be done like this, as this can cause
	# side effects. The assignment of the global position should be something
	# authomatic, or at least managed by the own entity.
	if _entity.global_position == current_target_global_position:
		path_indicators.pop_front().queue_free()

		_entity.entity_grid_component.set_position(current_target_grid_position)
		current_target_grid_position = null
		current_target_global_position = null

		# The movement component has reached its current target, and the path array
		# is empty. It has reached its destination.
		if path.is_empty():
			return IdleMovementState.new(_entity)

	# The movement component hasn't reached the current target, if it has one.
	if current_target_grid_position:
		_entity.entity_grid_component.move_toward(
			current_target_global_position,
			1
		)
	# The movement component has reached its current target, and its going to
	# select the next target in the path array.
	elif !path.is_empty():
		current_target_grid_position = path[0]
		current_target_global_position = GlobalAStarGrid.grid_position_to_global_position(current_target_grid_position)
		path.remove_at(0)
	
	return null


func _init(entity: Entity):
	_entity = entity

func _ready():
	_entity.notify(Component.ComponentCode.MOVING)
	path = GlobalAStarGrid.get_path_to_mouse_position(
		_entity.entity_grid_component.get_position()
	)

	for point in path:
		var indicator = preload("res://nodes/movement_indicator.tscn").instantiate()
		indicator.entity_grid_component.set_position(point)
		get_node("/root/world/ui").add_child(indicator)
		path_indicators.append(indicator)

func _exit_tree():
	# Remove any path indicators that might still exist.
	for indicator in path_indicators:
		indicator.queue_free()
