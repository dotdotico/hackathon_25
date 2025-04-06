# JumpingState.gd
extends State
class_name FallingState

# basic functions
func enter() -> void:
	character.jump()
	state_machine.can_jump = false
	# other junk

func physics_update(delta: float) -> void:
	var direction = state_machine.input_handler.move_direction
	if direction == null:
		direction = Vector3.ZERO
	state_machine._on_move(direction, delta)
	if character.is_on_floor():
		transition_to(&"IdleState")

func exit() -> void:
	pass
