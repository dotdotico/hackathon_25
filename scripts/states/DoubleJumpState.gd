# DoubleJumpState.gd
extends State
class_name DoubleJumpState

var jump_held : bool

# basic functions
func enter() -> void:
	#print("DJump: Enter")
	character.jump()
	state_machine.can_jump = false
	jump_held = true
	character.set_gravity_scale(1.0)

func physics_update(delta: float) -> void:
	var direction = state_machine.input_handler.move_direction
	
	jump_held = Input.is_action_pressed("action_jump")
	#transitions
	if character.is_on_floor():
		transition_to(&"IdleState")
	if character.velocity.y < 0 or not jump_held:
		transition_to(&"FallingState")
	
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	#print("DJump: Exit")
	state_machine.can_jump = false
