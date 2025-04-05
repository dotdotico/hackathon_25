extends CharacterBody3D

# Exported variables for tuning movement
@export var camera_sensitivity := 0.01
@export var sprint_multiplier := 2.0
@export var crouch_multiplier := 0.5
@export var acceleration := 10.0 # Increased
@export var deceleration := 15.0 # Increased
@export var air_deceleration := 3.0
@export var rotation_speed := 5.0 #used by children

# onready vars, node references
@onready var input_handler: Node = $InputHandler
@onready var camera_pivot_yaw: Node3D = $CameraPivotYaw
@onready var camera_pivot_pitch: Node3D = $CameraPivotYaw/CameraPivotPitch
@onready var state_machine: Node = $StateMachine
@onready var human: Node3D = $Human
@onready var kitsune: Node3D = $Kitsune
@onready var human_collider: CollisionShape3D = $HumanCollider
@onready var kitsune_collider: CollisionShape3D = $KitsuneCollider

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var target_velocity := Vector3.ZERO
var dash_direction := Vector3.ZERO
var has_movement_input := false

# declare callable funcs
var current_move_func: Callable
var current_jump_func: Callable
var current_attack_func: Callable
var current_dash_func: Callable
var current_sprint_func: Callable
var current_crouch_func: Callable

# declare changeable node refs
var visuals: Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_form_functions()
	swap_collider() # Added

func set_form_functions() -> void:
	if state_machine.current_form == state_machine.Form.HUMAN:
		current_move_func = human.human_move
		current_jump_func = human.human_jump
		current_attack_func = human.human_attack
		current_dash_func = human.human_dash
		current_sprint_func = human.human_sprint #added
		current_crouch_func = human.human_crouch #added
		visuals = human.get_node("HumanVisuals")
	elif state_machine.current_form == state_machine.Form.KITSUNE:
		current_move_func = kitsune.kitsune_move
		current_jump_func = kitsune.kitsune_jump
		current_attack_func = kitsune.kitsune_attack
		current_dash_func = kitsune.kitsune_dash
		current_sprint_func = kitsune.kitsune_sprint #added
		current_crouch_func = kitsune.kitsune_crouch #added
		visuals = kitsune.get_node("KitsuneVisuals")

func swap_collider():
	human_collider.disabled = kitsune.visible
	kitsune_collider.disabled = human.visible

func _physics_process(delta: float) -> void:
	var current_gravity = gravity
	if not is_on_floor():
		velocity.y -= current_gravity * delta

	var deceleration_value = deceleration if is_on_floor() else air_deceleration
	velocity.x = lerp(velocity.x, target_velocity.x, (acceleration if has_movement_input else deceleration_value) * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, (acceleration if has_movement_input else deceleration_value) * delta)

	move_and_slide()
	
	# end of movement input for this frame
	has_movement_input = false

func on_rotate_horizontal(amount: float) -> void:
	camera_pivot_yaw.rotate_y(amount * camera_sensitivity)

func on_rotate_vertical(amount: float) -> void:
	camera_pivot_pitch.rotate_x(amount * camera_sensitivity)
	camera_pivot_pitch.rotation.x = clamp(camera_pivot_pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func move_character(move_direction: Vector3, delta: float) -> void:
	current_move_func.call(move_direction, delta)
	has_movement_input = true

func jump() -> void:
	current_jump_func.call()

func dash() -> void:
	current_dash_func.call()

func sprint() -> void:
	current_sprint_func.call()

func crouch() -> void:
	current_crouch_func.call()
	
func attack() -> void:
	current_attack_func.call()

func swap_form(new_form):
	# We already swapped the form in the state machine, now what does the character do with that?
	if new_form == state_machine.Form.KITSUNE:
		kitsune.visible = true
		human.visible = false
	else:
		human.visible = true
		kitsune.visible = false
	set_form_functions()
	swap_collider()
