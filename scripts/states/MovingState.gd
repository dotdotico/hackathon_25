# MovingState.gd
extends State
class_name MovingState

func enter() -> void:
	print("MovingState entered")
	state_machine.can_jump = true
	state_machine.can_dash = true

func physics_update(delta:float) -> void:
	var direction: Vector3 = state_machine.input_handler.move_direction
	
	if character.velocity.y < 0.0:
		transition_to(&"FallingState")
	
	if character.velocity.length_squared() <= 0.01 and character.is_on_floor():
		transition_to(&"IdleState") # Transition to idle
		return
	
	if Input.is_action_pressed("action_sprint"):
		transition_to(&"SprintingState")
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	pass
