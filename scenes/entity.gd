class_name Entity extends Node2D

var entity_grid_component: EntityGridComponent = EntityGridComponent.new(self)
var movement_component: MovementComponent = null

func _ready():
	assert(entity_grid_component != null)

	# TODO: Remove this initial position.
	entity_grid_component.set_position(Vector2i(2, -1))

func notify(code: Component.ComponentCode):
	movement_component.receive(code)
	$animation_component.receive(code)
	entity_grid_component.receive(code)

func entity_selected():
	EntityManager.selected_entity = self

	if !movement_component:
		movement_component = MovementComponent.new()
		add_child(movement_component)

	if !EntityManager.selected_entity_changed.is_connected(_on_entity_manager_entity_changed):
		EntityManager.selected_entity_changed.connect(_on_entity_manager_entity_changed)

func _on_entity_manager_entity_changed(entity: Entity):
	# As the entity is null, deselect
	# TODO: If this was a collection of entities, we should search for the entity
	# in the collection, and if it's not found, deselect and disconnect
	if !entity:
		($selector_component as SelectorComponent).deselect()
		EntityManager.selected_entity_changed.disconnect(_on_entity_manager_entity_changed)

		if movement_component:
			movement_component.queue_free()
			remove_child(movement_component)
			movement_component = null
