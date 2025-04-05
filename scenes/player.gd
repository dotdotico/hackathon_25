# player
extends CharacterBody3D

@onready var input_handler: Node = $InputHandler
@onready var camera_pivot_yaw: Node3D = $CameraPivotYaw
@onready var camera_pivot_pitch: Node3D = $CameraPivotYaw/CameraPivotPitch

@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var move_speed := 5.0
@export var move_acceleration := 5.0
@export var jump_velocity := 5.0
@export var dash_speed := 10.0
@export var dash_duration := 1.0
@export var camera_sensitivity := 0.2
@export var camera_control_enabled := true

# States
var is_dashing := false
var is_diving := false
var is_jumping := false
var is_crouching := false

# Variables
var dash_timer := 0.0
var dash_direction := Vector3.ZERO
var move_direction := Vector3.ZERO
var current_move_direction := Vector3.ZERO

# Connect signals
func _ready():
	if input_handler:
		input_handler.connect("move", _on_move)
		input_handler.connect("action_jump", _on_jump)
		input_handler.connect("action_crouch", _on_crouch)
		input_handler.connect("action_dash", _on_dash)
		input_handler.connect("action_one", _on_action_one)
		input_handler.connect("action_two", _on_action_two)
		input_handler.connect("rotate_camera_horizontal", _on_camera_horizontal)
		input_handler.connect("rotate_camera_vertical", _on_camera_vertical)
	else:
		printerr("ERROR: No InputHandler component found as child.")
	
	# Mouse capture
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Connect signals
func _on_move(direction:Vector3):
	if not is_dashing:
		# Get the forward direction from the YAW pivot (horizontal rotation)
		var camera_forward = camera_pivot_yaw.global_transform.basis.z * -1
		camera_forward.y = 0
		camera_forward = camera_forward.normalized()

		# Get the right direction from the YAW pivot
		var camera_right = camera_pivot_yaw.global_transform.basis.x

		var move_direction = camera_forward * direction.z + camera_right * direction.x
		move_direction = move_direction.normalized()

		velocity.x = move_direction.x * move_speed
		velocity.z = move_direction.z * move_speed

func _on_jump():
	if is_on_floor() and not is_jumping:
		jump()
		is_jumping = true
	elif not is_on_floor():
		print("Cannot yet jump in mid-air.")
	else:
		print("We are jumping already.")

func _on_crouch():
	if not is_crouching:
		crouch()

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
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Movement
	velocity.x = lerp(velocity.x, move_direction.x * move_speed, 0.2)
	velocity.z = lerp(velocity.z, move_direction.z * move_speed, 0.2)
	
	# Finally....
	move_and_slide()


# Core movement
func jump():
	velocity.y = jump_velocity

func dash():
	pass

func crouch():
	pass

# Camera
func _on_camera_horizontal(amount: float):
	amount *= camera_sensitivity
	if camera_control_enabled:
		camera_pivot_yaw.rotate_y(deg_to_rad(amount))
	
func _on_camera_vertical(amount: float):
	amount *= camera_sensitivity
	if camera_control_enabled:
		camera_pivot_pitch.rotate_x(deg_to_rad(amount))
		camera_pivot_pitch.rotation.x = clamp(camera_pivot_pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))
