# JumpingState.gd
extends State
class_name JumpingState

# basic functions
func enter() -> void:
	character.jump()
	state_machine.can_jump = false
	# other junk

func physics_update(delta: float) -> void:
	if character.is_on_floor():
		transition_to(&"IdleState")

func exit() -> void:
	pass
