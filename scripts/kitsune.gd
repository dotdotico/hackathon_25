extends Node

@onready var character: CharacterBody3D = get_parent()

@export var kitsune_move_speed: float = 10.0
@export var kitsune_jump_height: float = 8.0

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func kitsune_move(move_direction: Vector3):
	var camera_forward: Vector3 = character.camera_pivot_pitch.global_transform.basis.z * -1
	camera_forward.y = 0
	camera_forward = camera_forward.normalized()
	var camera_right: Vector3 = character.camera_pivot_pitch.global_transform.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var relative_movement_direction: Vector3 = camera_forward * move_direction.z + camera_right * move_direction.x
	relative_movement_direction.y = 0
	relative_movement_direction = relative_movement_direction.normalized()

	if relative_movement_direction != Vector3.ZERO:
		var target_rotation: float = -atan2(relative_movement_direction.z, relative_movement_direction.x)
		target_rotation -= PI / 2.0
		character.visuals.rotation.y = lerp_angle(character.visuals.rotation.y, target_rotation, character.rotation_speed )

	var movedir: Vector3 = relative_movement_direction * kitsune_move_speed
	character.velocity += movedir

func kitsune_jump():
	character.velocity.y = sqrt(2 * gravity * kitsune_jump_height)

func kitsune_attack():
	print("Kitsune attack")

func kitsune_dash():
	print("Kitsune dash")

func kitsune_sprint():
	print("Kitsune sprint")

func kitsune_crouch():
	print("Kitsune crouch")
	
func kitsune_action1():
	print("Kitsune action1")

func kitsune_action2():
	print("Kitsune action2")
