class_name IdleMovementState extends MovementState

var _movement_indicator_component: MovementIndicatorComponent = null
var _entity: Entity = null

func input(event: InputEvent) -> MovementState:
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				print(GlobalAStarGrid.is_mouse_position_walkable())
				if GlobalAStarGrid.is_mouse_position_walkable():
					return MovingMovementState.new(_entity)
	
	return null

func _init(entity: Entity):
	_entity = entity

func _ready():
	_entity.notify(Component.ComponentCode.IDLE)
	_movement_indicator_component = MovementIndicatorComponent.new()
	_entity.add_child(_movement_indicator_component)

func _exit_tree():
	_movement_indicator_component.queue_free()
