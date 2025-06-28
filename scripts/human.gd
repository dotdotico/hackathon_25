extends Node

@onready var character: CharacterBody3D = get_parent()

@export var human_move_speed: float = 8.0
@export var human_jump_height: float = 3

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func human_jump():
	character.velocity.y = sqrt(2 * gravity * human_jump_height)

func human_attack():
	print("Human attack")

func human_dash():
	print("Human dash")
	if character.is_on_floor():
		print("floor dash")
	else:
		print("air dash")

func human_sprint():
	print("Human sprint")

func human_crouch():
	print("Human crouch")

func human_interact():
	print("Human interact")
