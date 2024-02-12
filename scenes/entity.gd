class_name Entity extends Node2D

var grid_position: Vector2i = Vector2i(-2, -1)

var movement_component: MovementComponent = null

func _ready():
	# Spawn entity initial position
	position = GlobalAStarGrid.grid_position_to_global_position(grid_position)

func entity_selected():
	EntityManager.selected_entity = self

	if !movement_component:
		movement_component = MovementComponent.new()
		movement_component._on_status_changed.connect(_on_movement_component_status_changed)
		add_child(movement_component)

	if !EntityManager.selected_entity_changed.is_connected(_on_entity_manager_entity_changed):
		EntityManager.selected_entity_changed.connect(_on_entity_manager_entity_changed)

func _on_movement_component_status_changed(status: MovementComponent.Status):
	match(status):
		MovementComponent.Status.MOVING:
			$animation_component/animation_tree["parameters/playback"].travel("walk")
		MovementComponent.Status.IDLE:
			$animation_component/animation_tree["parameters/playback"].travel("idle")

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
