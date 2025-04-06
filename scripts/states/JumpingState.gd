# JumpingState.gd
extends State
class_name JumpingState

var jump_held : bool

# basic functions
func enter() -> void:
	anim_player = character.anim_player
	if anim_player:
		anim_player.play(&"jumping")
	#print("Jump: Enter")
	character.jump()
	jump_held = true
	character.set_gravity_scale(1.2)

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
	#print("Jump: Exit")
	pass
