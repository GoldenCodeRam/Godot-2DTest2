extends Control

@export var _popup_menu: PopupMenu
@export var _selector: Selector

func _ready():
	_selector.input_event.connect(input_event)

func input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT:
		var mouse_position := get_viewport().get_mouse_position()
		print(get_parent())
		_popup_menu.popup(Rect2(mouse_position.x, mouse_position.y, _popup_menu.size.x, _popup_menu.size.y))
