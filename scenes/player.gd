# player
extends CharacterBody3D

@onready var input_handler: Node = $InputHandler
@export var move_speed := 5.0
@export var jump_velocity := 5.0
@export var dash_speed := 10.0
@export var dash_duration := 1.0

var is_dashing := false
var is_jumping := false
var dash_timer := 0.0
var dash_dir := Vector3.ZERO

func _ready():
	if input_handler:
		input_handler.connect("move", _on_move)
		input_handler.connect("action_jump", _on_jump)
		input_handler.connect("action_crouch", _on_crouch)
		input_handler.connect("action_dash", _on_dash)
		input_handler.connect("action_one", _on_action_one)
		input_handler.connect("action_two", _on_action_two)
	else:
		printerr("WARNING: No InputHandler component found as child.")

# Connect signals
func _on_move():
	pass

func _on_jump():
	if not is_jumping:
		jump()

func _on_crouch():
	pass

func _on_dash():
	if not is_dashing:
		dash()

func _on_action_one():
	pass

func _on_action_two():
	pass


# Process

func _physics_process(delta: float) -> void:
	# Gravity
	# Movement Mechanics
	pass


# Core movement
func jump():
	pass

func dash():
	pass
