# FallingState.gd
extends State
class_name FallingState

func enter() -> void:
	print("FallingState entered")

func physics_update(delta:float) -> void:
	var direction: Vector3 = state_machine.input_handler.move_direction
	
	if character.velocity.length_squared() <= 0.01 and character.is_on_floor():
		transition_to(&"IdleState") # Transition to idle
		return
	
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	pass
