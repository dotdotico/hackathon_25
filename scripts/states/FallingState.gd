# FallingState.gd
extends State
class_name FallingState

#vars
@export var gravity_scale_falling := 3.0

func enter() -> void:
	anim_player = character.anim_player
	if anim_player:
		anim_player.play(&"falling")
	#print("Falling")
	character.set_gravity_scale(gravity_scale_falling)

func physics_update(delta:float) -> void:
	var direction: Vector3 = state_machine.input_handler.move_direction
	
	if character.velocity.length_squared() <= 0.01 and character.is_on_floor():
		transition_to(&"IdleState") # Transition to idle
	
	if character.is_on_floor():
		transition_to(&"MovingState")
	
	if Input.is_action_pressed("action_jump") and state_machine.can_jump:
		transition_to(&"DoubleJumpState")
	
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	pass
