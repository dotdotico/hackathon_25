# DashingState.gd
extends State
class_name DashingState

@export var dash_timer := 2.0

func enter() -> void:
	print("Idle: Enter")
	state_machine.can_jump = true
	state_machine.can_dash = false
	pass

func physics_update(_delta: float) -> void:
	# Not on floor check
	if not character.is_on_floor() and character.velocity.y < 0.0:
		transition_to(&"FallingState")
		return # Exit early

	# move check
	if character.is_on_floor() and character.velocity.length_squared() >= 0.01:
		transition_to(&"MovingState") # Transition to moving state if we "want" to move

func exit() -> void:
	print("Idle: Exit")
	pass
