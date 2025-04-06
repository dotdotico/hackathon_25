# AttackingState.gd
extends State
class_name AttackingState

var still_attacking := true

func enter() -> void:
	print("Attacking: Enter")
	# declare all bools on the state
	state_machine.can_jump = false
	state_machine.can_dash = false
	attack()

func physics_update(_delta: float) -> void:
	
	# Not on floor check
	if not character.is_on_floor() and character.velocity.y < 0.0:
		transition_to(&"FallingState")
		return # Exit early

	# move check
	if character.is_on_floor() and character.velocity.length_squared() >= 0.01:
		transition_to(&"MovingState") # Transition to moving state if we "want" to move

func exit() -> void:
	print("Attacking: Exit")
	pass

func attack():
	#all garabge in here
	pass
