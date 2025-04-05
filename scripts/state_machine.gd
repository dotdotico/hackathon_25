# state_machine.gd
extends Node
class_name StateMachine

enum Form {HUMAN, KITSUNE}

# export vars
@export var current_form: Form = Form.KITSUNE
@export var initial_state_key: StringName = &"Idle"

# onready vars
@onready var character: CharacterBody3D = get_parent() #state machine should be a child of the char
@onready var input_handler: InputHandler = character.get_node("InputHandler")

# internal vars
var states: Dictionary #dict of all states
var current_state: State

# useful bools for all states to change
var can_jump := true
var can_dash := true
var can_sprint := true

func _ready() -> void:
	# Find child states
	for child in get_children():
		if child is State:
			var state_node = child as State
			states[state_node.name] = state_node # Use the node's name as the key
			# Deliver important references to the child State nodes
			state_node.state_machine = self
			state_node.character = self.character
			print("Registered State: ", state_node.name)
		else:
			printerr("Warning: Child '", child.name, "' of StateMachine is not a State.")
	
	######### AI GENERATED (BUT HEAVILY EDITED) CODE BELOW ###########
	# Enter initial State
	if states.has(initial_state_key):
		current_state = states[initial_state_key]
		print("Entering init State: ", current_state.name)
		current_state.enter()
	elif not states.is_empty():
		printerr("Initial state not found. Falling back to first state.")
		states[0].enter() #fallback idk if it works
	else:
		printerr("No states found.")
	
	# Connect signals from InputHandler
	var input_handler = character.get_node("InputHandler")
	input_handler.move.connect(_on_move)
	input_handler.action_jump.connect(_on_jump)
	input_handler.action_attack.connect(_on_attack)
	input_handler.action_interact.connect(_on_interact)
	input_handler.action_dash.connect(_on_dash)
	input_handler.action_form_swap.connect(_on_form_swap)
	input_handler.rotate_camera.connect(_on_camera_rotate)

func _physics_process(delta: float) -> void:
	# pass this onto the current state, calling each physics frame
	if current_state:
		current_state.physics_update(delta)
	
	#DEBUG
	print("Current State: ", current_state.name if current_state else "None")

func transition_to(target_state_key: StringName) -> void:
	# Handled by children so this is error handling
	if not states.has(target_state_key): #does the list of all states even have this state?
		printerr("Can't transition, State: ", target_state_key, " not found.")
		return
	# Don't transition if we are already there
	if current_state and current_state.name == target_state_key:
		return
	
	# Exit logic
	if current_state: #exists
		print("Exiting State: ", current_state.name)
		current_state.exit()
	else:
		printerr("Can't transition out of a null state. How did you get here?!")
	
	# Update refs
	var new_state: State = states[target_state_key]
	current_state = new_state
	
	# Enter logic
	print("Entering State: ", current_state.name)
	current_state.enter()
	########## AI GENERATED (BUT EDITED) CODE ABOVE ############

func _on_move(direction: Vector3) -> void:
	# Attempt to move
	character.set_intended_direction(direction)

func _on_jump() -> void:
	# Attempt to jump
	if not can_jump:
		#inside the state is character.jump() and setting the bools
		transition_to(&"Jumping")
	else:
		print("Can't jump.")

func _on_dash() -> void:
	# attempt to dash
	if can_dash:
		transition_to(&"Dashing")
	else:
		print("Can't dash.")

func _on_attack() -> void:
	transition_to(&"Attacking")

func _on_sprint() -> void:
	transition_to(&"Sprinting")

func _on_interact() -> void:
	transition_to(&"Interacting")

func _on_form_swap() -> void:
	if current_form == Form.HUMAN:
		current_form = Form.KITSUNE
	else:
		current_form = Form.HUMAN
	character.swap_form(current_form) # Call function on CharacterBody3D and to set new form.
	transition_to(&"Swapping")
	print("Form swapped to: ", Form.keys()[current_form])

func _on_camera_rotate(amount,delta) -> void:
	#debug
	#print(str(amount) + ":" + str(delta))
	character.on_camera_rotate(amount,delta)
