class_name EntityAnimationController extends AnimationController

func animate(
	code: Component.ComponentCode,
	state_machine: AnimationNodeStateMachinePlayback
):
	match code:
		Component.ComponentCode.MOVING:
			state_machine.travel("walk")
		_:
			state_machine.travel("idle")
