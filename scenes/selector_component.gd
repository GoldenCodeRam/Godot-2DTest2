class_name SelectorComponent extends Area2D

enum Status {
	SELECTED,
	DESELECTED,
	HOVERED,
	HIDDEN,
}

@export var selector_sprite: Sprite2D
@export var collision_shape: CollisionShape2D

func _ready():
	selector_sprite.visible = false

	mouse_entered.connect(_hover)
	mouse_exited.connect(_exit)

var status: Status = Status.HIDDEN:
	get:
		return status
	set(value):
		# When the status is SELECTED, then the status can't be changed by the
		# selector, as the status of the selector is being used by instances
		# outside the node.
		if status == Status.SELECTED and value != Status.DESELECTED:
			return

		match value:
			Status.HIDDEN, Status.DESELECTED:
				hide_selector()
				status = value
			Status.HOVERED, Status.SELECTED:
				show_selector()
				status = value

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			if get_parent() is Entity:
				# If the selector is selected, notify the parent.
				get_parent().entity_selected()
				select()

func _on_entity_manager_entity_changed(_entity: Entity):
	if EntityManager.selected_entity:
		status = Status.SELECTED
	else:
		status = Status.DESELECTED

func _hover():
	status = Status.HOVERED

func _exit():
	status = Status.HIDDEN

func select():
	status = Status.SELECTED

func deselect():
	status = Status.DESELECTED

func show_selector():
	selector_sprite.visible = true

func hide_selector():
	selector_sprite.visible = false

