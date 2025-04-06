extends Node

@onready var character: CharacterBody3D = get_parent()

@export var kitsune_move_speed: float = 10.0
@export var kitsune_jump_height: float = 2.0

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

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
	
func kitsune_interact():
	print("Kitsune interact")
