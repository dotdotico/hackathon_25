# IdleState.gd
extends State
class_name IdleState

func enter() -> void:
	print("Idle: Enter")
	state_machine.can_jump = true
	state_machine.can_dash = true
	pass

func physics_update(delta: float) -> void:
	# 1. Fall Check
	if not character.is_on_floor():
		transition_to(&"FallingState")
		return # Exit early
	
	# 2. Want to move check
	if character.intended_direction.length() >= 0.001:
		transition_to(&"WalkingState") # Transition to idle if no movement

func exit() -> void:
	print("Idle: Exit")
	pass
