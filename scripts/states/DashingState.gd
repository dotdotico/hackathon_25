# DashingState.gd
extends State
class_name DashingState

@export var dash_timer := 0.5
@export var dash_force := 20.0
var dash_duration : float
var target_direction : Vector3

func enter() -> void:
	print("Dash: Enter")
	state_machine.can_dash = false
	dash_duration = dash_timer
	target_direction = character.target_direction
	character.set_gravity_scale(0.0)

func physics_update(delta: float) -> void:
	if dash_duration > 0.35:
		dash_duration -= delta
		character.velocity.y = 0.1
		character.velocity = target_direction * dash_force
	elif dash_duration > 0.0:
		dash_duration -= delta
		character.velocity = Vector3.ZERO
		
	else:
		# move check
		if character.is_on_floor():
			if character.velocity.length_squared() >= 0.01:
				transition_to(&"MovingState")
			else:
				transition_to(&"IdleState")
		else:
			transition_to(&"FallingState")

func exit() -> void:
	print("Dash: Exit")
	state_machine.can_dash = true
