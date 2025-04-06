# IdleState.gd
extends State
class_name IdleState

func enter() -> void:
	print("Idle: Enter")
	state_machine.can_jump = true
	state_machine.can_dash = true
	pass

func physics_update(_delta: float) -> void:
	
	
	# Not on floor check
	if not character.is_on_floor():
		transition_to(&"FallingState")
		return # Exit early	
	# Want to move check
	if state_machine.input_handler.move_direction.length_squared() >= 0.01:
		transition_to(&"MovingState") # Transition to moving state if we "want" to move
		

func exit() -> void:
	print("Idle: Exit")
	pass
