extends CharacterBody3D

# Exported variables for tuning movement
@export var move_speed := 10.0
@export var jump_velocity := 6.0
@export var rotation_speed := 5.0
@export var camera_sensitivity := 0.01
@export var sprint_multiplier := 2.0
@export var crouch_multiplier := 0.5
@export var acceleration := 10.0
@export var deceleration := 15.0
@export var air_deceleration := 3.0
@export var extra_gravity_multiplier := 1.5
@export var fast_fall_gravity_multiplier := 2.0

# onready vars
@onready var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var input_handler:Node = $InputHandler
@onready var camera_pivot_yaw:Node3D = $CameraPivotYaw
@onready var camera_pivot_pitch:Node3D = $CameraPivotYaw/CameraPivotPitch
@onready var state_machine:Node = $StateMachine
@onready var visuals:Node3D = $Kitsune/KitsuneVisuals

# internal vars
var target_velocity := Vector3.ZERO
var dash_direction := Vector3.ZERO
var has_movement_input := false

func _ready():
	# Capture mouse input, move this later
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# declare all the functions for the active form
	set_form_functions()

func set_form_functions():
	if state_machine.current_form == state_machine.Form.HUMAN:
		#human functions here
		pass
	if state_machine.current_form == state_machine.Form.HUMAN:
		#kitsune functions here
		pass

func _physics_process(delta):
	# Apply gravity
	var current_gravity = gravity
	if not is_on_floor():
		velocity.y -= current_gravity * delta

	# Apply acceleration and deceleration
	var deceleration_value = deceleration if is_on_floor() else air_deceleration
	velocity.x = lerp(velocity.x, target_velocity.x, (acceleration if has_movement_input else deceleration_value) * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, (acceleration if has_movement_input else deceleration_value) * delta)

	# Finally...
	move_and_slide()

func move_character(move_direction: Vector3, delta: float):
	# Rotate move_direction to camera forward direction.
	var camera_forward = camera_pivot_pitch.global_transform.basis.z * -1
	camera_forward.y = 0
	camera_forward = camera_forward.normalized()
	var camera_right = camera_pivot_pitch.global_transform.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var relative_move_direction = camera_forward * move_direction.z + camera_right * move_direction.x
	relative_move_direction.y = 0
	relative_move_direction = relative_move_direction.normalized()
	# Rotate character visuals
	if relative_move_direction != Vector3.ZERO:
		var target_rotation = -atan2(relative_move_direction.z, relative_move_direction.x)
		target_rotation -= PI / 2.0
		visuals.rotation.y = lerp_angle(visuals.rotation.y, target_rotation, rotation_speed * delta)
	
	# move the character
	var movedir = relative_move_direction * move_speed * delta
	velocity += movedir
	
	# we are moving via user move input
	has_movement_input = true

func on_rotate_horizontal(amount: float):
	camera_pivot_yaw.rotate_y(amount * camera_sensitivity)

func on_rotate_vertical(amount: float):
	camera_pivot_pitch.rotate_x(amount * camera_sensitivity)
	camera_pivot_pitch.rotation.x = clamp(camera_pivot_pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func jump():
	if is_on_floor():
		velocity.y = jump_velocity

func dash():
	pass

func sprint():
	pass

func crouch():
	pass
