class_name MovementComponent extends Component

@onready var entity: Entity = get_parent()

var _state: MovementState = null

func _ready():
	_state = IdleMovementState.new(entity)
	add_child(_state)

func _process(_delta: float):
	_handle_state(_state.move())

func _input(event):
	_handle_state(_state.input(event))

func _handle_state(state: MovementState):
	if state != null:
		_state.queue_free()
		_state = state
		add_child(state)
