class_name AnimationComponent extends Component

@export var animation_tree: AnimationTree
@export var animation_controller: AnimationController

func receive(code: ComponentCode):
	animation_controller.animate(code, animation_tree.get("parameters/playback"))
