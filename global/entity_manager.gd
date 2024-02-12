extends Node

signal selected_entity_changed

var selected_entity: Entity:
	get:
		return selected_entity
	set(value):
		selected_entity = value
		selected_entity_changed.emit(selected_entity)

func _input(event):
	if event is InputEventKey and event.is_pressed():
		match (event.keycode):
			KEY_ESCAPE:
				selected_entity = null

