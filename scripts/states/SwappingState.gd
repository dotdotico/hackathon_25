# SwappingState.gd
extends State
class_name SwappingState

var swap_is_done := false

func enter() -> void:
	print("Swap: Enter")
	state_machine.can_swap = false
	pass

func physics_update(_delta: float) -> void:
	# Not on floor check
	if not character.is_on_floor() and character.velocity.y < 0.0:
		#freeze in mid-air for a cool effect
		character.set_gravity_scale = 0.0
		character.velocity.y = 0

	if swap_is_done:
		#perform transition checks now
		if character.is_on_floor() and character.velocity.length_squared() >= 0.01:
			transition_to(&"MovingState") # Transition to moving state if we "want" to move

func exit() -> void:
	print("Swap: Exit")
	character.set_gravity_scale = 1.0
	state_machine.can_swap = true
	pass
