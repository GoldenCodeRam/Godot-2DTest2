extends Node

signal selected_entity_changed

var selected_entity: Entity:
	get:
		return selected_entity
	set(value):
		selected_entity = value
		selected_entity_changed.emit(selected_entity)
