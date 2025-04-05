extends Node

@onready var character: CharacterBody3D = get_parent()

@export var human_move_speed: float = 5.0
@export var human_jump_height: float = 12.0

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func human_move(move_direction: Vector3):
	var camera_forward: Vector3 = character.camera_pivot_pitch.global_transform.basis.z * -1
	camera_forward.y = 0
	camera_forward = camera_forward.normalized()
	var camera_right: Vector3 = character.camera_pivot_pitch.global_transform.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var relative_movement_direction: Vector3 = camera_forward * move_direction.z + camera_right * move_direction.x
	relative_movement_direction.y = 0
	relative_movement_direction = relative_movement_direction

	if relative_movement_direction != Vector3.ZERO:
		var target_rotation: float = -atan2(relative_movement_direction.z, relative_movement_direction.x)
		target_rotation -= PI / 2.0
		character.visuals.rotation.y = lerp_angle(character.visuals.rotation.y, target_rotation, character.rotation_speed)

	var movedir: Vector3 = relative_movement_direction * human_move_speed
	character.velocity += movedir

func human_jump():
	character.velocity.y = sqrt(2 * gravity * human_jump_height)

func human_attack():
	print("Human attack")

func human_dash():
	print("Human dash")

func human_sprint():
	print("Human sprint")

func human_crouch():
	print("Human crouch")

func human_action1():
	print("Human action1")
	
func human_action2():
	print("Human action2")
