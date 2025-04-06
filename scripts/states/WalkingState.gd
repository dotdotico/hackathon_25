extends State
class_name WalkingState

func enter() -> void:
	print("Entering WalkingState")

func physics_update(delta:float) -> void:
	if character.intended_direction.length() <= 0.001:
		transition_to(&"IdleState") # Transition to idle if no movement
	else:
		character.character_move(character.intended_direction, delta)

func exit() -> void:
	pass
