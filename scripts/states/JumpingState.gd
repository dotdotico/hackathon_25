# JumpingState.gd
extends State
class_name JumpingState

# basic functions
func enter() -> void:
	print("Jump: Enter")
	character.jump()
	state_machine.can_jump = false
	# other junk for double jump later

func physics_update(delta: float) -> void:
	var direction = state_machine.input_handler.move_direction
	if direction == null:
		direction = Vector3.ZERO
	
	if character.is_on_floor():
		transition_to(&"IdleState")
	
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	print("Jump: Exit")
	pass
