# state_machine.gd
extends Node

enum Form {HUMAN, KITSUNE}
enum State {IDLE, WALKING, JUMPING, FALLING, DASHING, SPRINTING, CROUCHING, ATTACKING, ACTION2}

# export vars
@export var current_form: Form = Form.KITSUNE
@export var current_state: State = State.IDLE

# onready vars
@onready var character: CharacterBody3D = get_parent() #this state machine should be a child

# track states
var has_jumped:bool
var has_dashed:bool
var has_air_crouched:bool

func _ready() -> void:
	# Connect signals from InputHandler
	var input_handler = character.get_node("InputHandler")
	input_handler.move.connect(_on_move)
	input_handler.action_jump.connect(_on_jump)
	input_handler.action_one.connect(_on_attack)
	input_handler.action_two.connect(_on_action_two)
	input_handler.action_dash.connect(_on_dash)
	input_handler.action_form_swap.connect(_on_form_swap)
	input_handler.rotate_camera.connect(_on_camera_rotate)

func _physics_process(delta: float) -> void:
	# debug
	print(State.keys()[current_state])
	
	# reset jump state
	if character.is_on_floor():
		land()
		if character.velocity.length() <= 0.1:
			current_state = State.IDLE
	elif current_state != State.JUMPING:
		current_state = State.FALLING

func _on_move(direction: Vector3, delta: float) -> void:
	#if current_state != State.DASHING or State.JUMPING: # we arent doing any special manuevers
	if current_state != State.DASHING: # we arent doing any special manuevers
		if character.is_on_floor():
			current_state = State.WALKING
		character.move_character(direction, delta) # Call move function on player
	else:
		character.move_character(Vector3.ZERO, delta) #no move input delivered, need to specify when??

func _on_jump() -> void:
	if current_state != State.JUMPING and not has_jumped:
		current_state = State.JUMPING
		character.jump()
		has_jumped = true
	else:
		print("cannot jump right now.")

func _on_dash() -> void:
	if current_state != State.DASHING: #check if not dashing.
		current_state = State.DASHING
		character.dash() # Call function on CharacterBody3D, let the character decide what to do if theyre on the floor or not.
		has_dashed = true
	else:
		print("cannot dash right now.")

func _on_attack() -> void:
	character.attack()
	current_state = State.ATTACKING

func _on_action_two() -> void:
	character.action2()
	current_state = State.ACTION2

func _on_form_swap() -> void:
	if current_form == Form.HUMAN:
		current_form = Form.KITSUNE
	else:
		current_form = Form.HUMAN
	character.swap_form(current_form) # Call function on CharacterBody3D and to set new form.
	print("Form swapped to: ", Form.keys()[current_form])

func _on_camera_rotate(amount,delta):
	#debug
	#print(str(amount) + ":" + str(delta))
	character.on_camera_rotate(amount,delta)

func land():
	has_jumped = false
	has_dashed = false
	has_air_crouched = false
