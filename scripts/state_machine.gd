extends Node

enum Form {HUMAN, KITSUNE}
enum State {IDLE, WALKING, JUMPING, DASHING, SPRINTING, CROUCHING}

# export vars
@export var current_form = Form.KITSUNE
@export var current_state = State.IDLE

# onready vars
@onready var character:CharacterBody3D = get_parent() #this state machine should be a child
@onready var kitsune:Node3D = $"../Kitsune"
@onready var human:Node3D = $"../Human"

func _ready():
	# Connect signals from InputHandler
	var input_handler = character.get_node("InputHandler")
	input_handler.move.connect(_on_move)
	input_handler.action_jump.connect(_on_jump)
	input_handler.action_dash.connect(_on_dash)
	input_handler.action_form_swap.connect(_on_form_swap)

func _on_move(direction, delta):
	if current_state != State.DASHING: # we arent dashing rn
		current_state = State.WALKING
		character.move_character(direction, delta) # Call function on CharacterBody3D
	else:
		character.move_character(Vector3.ZERO) #dashing, no move input delivered

func _on_jump():
	if current_state != State.DASHING:
		current_state = State.JUMPING
		character.jump() # Call function on CharacterBody3D
	else:
		print("cannot jump while dashing")

func _on_dash():
	if current_state == State.JUMPING and not State.DASHING:
		current_state = State.DASHING
		character.dash() # Call function on CharacterBody3D
	else:
		print("cannot dash right now")

func _on_form_swap():
	character.swap_form() # Call function on CharacterBody3D
	if current_form == Form.HUMAN:
		current_form = Form.KITSUNE
	else:
		current_form = Form.HUMAN
	print("Form swapped to: ", current_form)
