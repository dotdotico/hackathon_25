extends Node

enum Form {HUMAN, KITSUNE}
enum State {IDLE, WALKING, JUMPING, DASHING, SPRINTING, CROUCHING, ATTACKING, ACTION2}

# export vars
@export var current_form: Form = Form.KITSUNE
@export var current_state: State = State.IDLE

# onready vars
@onready var character: CharacterBody3D = get_parent() #this state machine should be a child

# internal vars
var is_on_floor:bool

func _ready() -> void:
	# Connect signals from InputHandler
	var input_handler = character.get_node("InputHandler")
	input_handler.move.connect(_on_move)
	input_handler.action_jump.connect(_on_jump)
	input_handler.action_one.connect(_on_attack)
	input_handler.action_two.connect(_on_action_two)
	input_handler.action_dash.connect(_on_dash)
	input_handler.action_form_swap.connect(_on_form_swap)

func _physics_process(delta: float) -> void:
	#reset jump state
	if is_on_floor and current_state == State.JUMPING:
		current_state = State.IDLE
	print(str(current_state))


func _on_move(direction: Vector3, delta: float) -> void:
	if current_state != State.DASHING or State.JUMPING: # we arent dashing rn
		current_state = State.WALKING
		character.move_character(direction, delta) # Call function on CharacterBody3D
	else:
		character.move_character(Vector3.ZERO) #dashing, no move input delivered

func _on_jump() -> void:
	if current_state != State.DASHING or State.JUMPING:
		current_state = State.JUMPING
		character.jump()
	else:
		print("cannot jump right now.")

func _on_dash() -> void:
	if current_state == State.JUMPING and current_state != State.DASHING: #check if jumping, and not dashing.
		current_state = State.DASHING
		character.dash() # Call function on CharacterBody3D
	else:
		print("cannot dash right now.")

func _on_attack() -> void:
	character.attack()
	current_state = State.ATTACKING

func _on_action_two() -> void:
	print("action 2 was called")
	current_state = State.ACTION2

func _on_form_swap() -> void:
	if current_form == Form.HUMAN:
		current_form = Form.KITSUNE
	else:
		current_form = Form.HUMAN
	character.swap_form(current_form) # Call function on CharacterBody3D and to set new form.
	print("Form swapped to: ", str(current_form))
