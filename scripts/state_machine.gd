# state_machine.gd
extends Node
class_name StateMachine

enum Form {HUMAN, KITSUNE}

# export vars
@export var current_form: Form = Form.KITSUNE
@export var initial_state_key: StringName = &"IdleState"

# onready vars
@onready var character: GameCharacter = get_parent() #state machine should be a child of the char
@onready var input_handler: InputHandler = character.get_node("InputHandler")

# internal vars
var states: Dictionary = {} #dict of all states
var current_state: State
var anim_player: AnimationPlayer

# useful bools for all states to change
var can_jump := true
var can_dash := true
var can_sprint := true
var can_swap := true

func _ready() -> void:
	# Find child states
	for child in get_children():
		if child is State:
			var state_node = child as State
			states[state_node.name] = state_node # Use the node's name as the key
			# Deliver important references to the child State nodes
			state_node.state_machine = self
			state_node.character = self.character
#			state_node.anim_player = self.anim_player
			print("Registered State: ", state_node.name)
		else:
			printerr("Warning: Child '", child.name, "' of StateMachine is not a State.")
	
	######### AI GENERATED (BUT HEAVILY EDITED) CODE BELOW ###########
	# Enter initial State
	if states.has(initial_state_key):
		current_state = states[initial_state_key]
		print("Entering init State: ", current_state.name)
		current_state.enter()
	elif states.is_empty():
		printerr("No states found.")
	
	# Connect signals from InputHandler
	input_handler.move.connect(_on_move)
	input_handler.action_jump.connect(_on_jump)
	input_handler.action_attack.connect(_on_attack)
	input_handler.action_interact.connect(_on_interact)
	input_handler.action_sprint.connect(_on_sprint)
	input_handler.action_dash.connect(_on_dash)
	input_handler.action_form_swap.connect(_on_form_swap)
	input_handler.rotate_camera.connect(_on_camera_rotate)
	
	# Find current animation player as defined by the character script
	anim_player = character.anim_player

func _physics_process(delta: float) -> void:
	# pass this onto the current state, calling each physics frame
	if current_state:
		current_state.physics_update(delta)
	
	#DEBUG
	#print("Current State: ", current_state.name if current_state else "None")

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

func _on_move(direction: Vector3, delta:float) -> void:
	character.on_move(direction, delta)

func _on_jump() -> void:
	#HARD CODED OVERRIDE, WE CAN ALWAYS TRY TO JUMP NO MATTER THE STATE
	# Attempt to jump
	if can_jump:
		transition_to(&"JumpingState")
	else:
		print("Can't jump.")

func _on_dash() -> void:
	#HARD CODED OVERRIDE, WE CAN ALWAYS TRY TO DASH NO MATTER THE STATE
	# Attempt to dash
	if can_dash:
		transition_to(&"DashingState")
	else:
		print("Can't dash.")

func _on_attack() -> void:
	#HARD CODED OVERRIDE, WE CAN ALWAYS TRY TO ATTACK NO MATTER THE STATE
	# Attempt to attack
	pass
	#transition_to(&"AttackingState")

func _on_sprint() -> void:
	if can_sprint:
		transition_to(&"SprintingState")
	else:
		print("Can't sprint.")

func _on_interact() -> void:
	pass
	#if can_interact:
	#	transition_to(&"InteractingState")

func _on_form_swap() -> void:
	#find animation player
	anim_player = character.anim_player
	
	if can_swap:
		if current_form == Form.HUMAN:
			current_form = Form.KITSUNE
		else:
			current_form = Form.HUMAN
		transition_to(&"SwappingState")
		print("Form swapped to: ", Form.keys()[current_form])
func _get_current_form() -> Form:
	return current_form

func _on_camera_rotate(amount,delta) -> void:
	#debug
	#print(str(amount) + ":" + str(delta))
	character.on_camera_rotate(amount,delta)
