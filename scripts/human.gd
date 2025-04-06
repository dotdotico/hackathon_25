extends Node

@onready var character: CharacterBody3D = get_parent()

@export var human_move_speed: float = 1.5
@export var human_jump_height: float = 2.0

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

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

func human_interact():
	print("Human interact")
