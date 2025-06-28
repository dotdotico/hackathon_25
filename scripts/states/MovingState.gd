# MovingState.gd
extends State
class_name MovingState

func enter() -> void:
	anim_player = character.anim_player
	if anim_player:
		anim_player.play(&"running")
	#print("MovingState entered")
	state_machine.can_jump = true
	state_machine.can_dash = true
	state_machine.can_swap = true

func physics_update(delta:float) -> void:
	#anim_player.speed_scale = character.velocity.normalized().length_squared()
	var direction: Vector3 = state_machine.input_handler.move_direction
	
	if character.velocity.y < 0.0 and not character.is_on_floor():
		transition_to(&"FallingState")
	
	if character.velocity.length_squared() <= 0.01 and character.is_on_floor():
		transition_to(&"IdleState") # Transition to idle
		return
	
	if Input.is_action_pressed("action_sprint"):
		transition_to(&"SprintingState")
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	#print("MovingState: Exit")
	state_machine.can_dash = true
	pass
