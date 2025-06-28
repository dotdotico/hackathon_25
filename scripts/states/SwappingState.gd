# SwappingState.gd
extends State
class_name SwappingState

var swap_is_done := false

func enter() -> void:
	anim_player = character.anim_player
	if anim_player:
		anim_player.play(&"swapping")
	#print("Swap: Enter")
	#state_machine.can_swap = false
	#state_machine.can_dash = false
	#state_machine.can_jump = false
	
	var morphs:Node3D = character.morphs
	for particles in morphs.get_children():
		particles.emitting = true
	for particles in morphs.get_children():
		await get_tree().create_timer(particles.lifetime - 0.5).timeout
		particles.emitting = false

func physics_update(_delta: float) -> void:
	swap_is_done = (anim_player.get_current_animation_position() == anim_player.get_current_animation_length())
	
	# Not on floor check
	if not character.is_on_floor() and character.velocity.y < 0.0:
		#freeze in mid-air for a cool effect
		character.set_gravity_scale(0.0)
		character.velocity.y = 0

	if swap_is_done or (state_machine._get_current_form() == state_machine.Form.HUMAN):
		#perform transition checks now
		if character.is_on_floor() and character.velocity.length_squared() >= 0.01:
			transition_to(&"MovingState") # Transition to moving state if we "want" to move
		else:
			transition_to(&"FallingState")

func exit() -> void:
	#print("Swap: Exit")
	character.set_gravity_scale(1.0)
	character.swap_form(state_machine.current_form) # Call function on CharacterBody3D and to set new form.
	state_machine.can_swap = true
	pass
