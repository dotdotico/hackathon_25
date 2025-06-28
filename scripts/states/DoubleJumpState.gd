# DoubleJumpState.gd
extends State
class_name DoubleJumpState

var jump_held : bool
@export var gravity_scale_djumping := 1.2 #a little less for some more oomph

# basic functions
func enter() -> void:
	anim_player = character.anim_player
	if anim_player:
		if anim_player.has_animation(&"airjump"):
			print('aj')
			anim_player.play(&"airjump")
		else:
			anim_player.play(&"jumping")
			anim_player.seek(0.0)
	#print("DJump: Enter")
	character.set_gravity_scale(gravity_scale_djumping)
	character.jump() #use jump height from def char jump
	state_machine.can_jump = false
	jump_held = true
	var particles:GPUParticles3D = character.double_jump_particles
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime - 0.1).timeout
	particles.emitting = false
	
func physics_update(delta: float) -> void:
	var direction = state_machine.input_handler.move_direction
	
	jump_held = Input.is_action_pressed("action_jump")
	#transitions
	if character.is_on_floor():
		transition_to(&"IdleState")
	if character.velocity.y < 1.5 or not jump_held:
		transition_to(&"FallingState")
	
	#enable movement
	state_machine._on_move(direction, delta)

func exit() -> void:
	#print("DJump: Exit")
	state_machine.can_jump = false
