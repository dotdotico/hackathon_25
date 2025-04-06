# SprintingState.gd
extends State
class_name SprintingState

@export var sprint_multiplier = 1.6

func enter() -> void:
	print("Sprint: Enter")
	state_machine.can_jump = true
	state_machine.can_sprint = false
	state_machine.can_dash = true
	state_machine.can_swap = false
	character.sprint_multiplier = sprint_multiplier

func physics_update(delta: float) -> void:
	if false:
		pass
	else:
		# move check
		if character.is_on_floor():
			if character.velocity.length_squared() >= 0.01:
				transition_to(&"MovingState")
			else:
				transition_to(&"IdleState")
		else:
			transition_to(&"FallingState")

func exit() -> void:
	print("Sprint: Exit")
	state_machine.can_sprint = true
	character.sprint_multiplier = 1.0
