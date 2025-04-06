# IdleState.gd
extends State
class_name IdleState

func enter() -> void:
	#print("Idle: Enter")
	state_machine.can_jump = true
	state_machine.can_dash = true
	pass

func physics_update(_delta: float) -> void:
	anim_player = character.anim_player
	if anim_player:
		anim_player.play(&"idle")
	# Not on floor check
	if not character.is_on_floor() and character.velocity.y < 0.0:
		transition_to(&"FallingState")

	# move check
	if character.is_on_floor() and character.velocity.length_squared() >= 0.01:
		transition_to(&"MovingState") # Transition to moving state if we "want" to move

func exit() -> void:
	#print("Idle: Exit")
	pass
