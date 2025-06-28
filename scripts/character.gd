extends CharacterBody3D
class_name GameCharacter

# Exported variables for tuning movement
@export var mouse_look_sensitivity:float = 0.01
@export var gamepad_look_sensitivity:float = 5
@export var crouch_multiplier:float = 0.5
@export var acceleration:float = 8.0
@export var deceleration:float = 12.0
@export var air_deceleration:float = 0.6
@export var rotation_speed:float = 12.0

# onready vars, node references
@onready var input_handler: Node = $InputHandler
@onready var camera_pivot_yaw: Node3D = $CameraPivotYaw
@onready var camera_pivot_pitch: Node3D = $CameraPivotYaw/CameraPivotPitch
@onready var state_machine: Node = $StateMachine
@onready var human: Node3D = $Human
@onready var human_collider: CollisionShape3D = $HumanCollider
@onready var human_anim_player: AnimationPlayer = $Human/HumanVisuals/human/AnimationPlayer
@onready var kitsune: Node3D = $Kitsune
@onready var kitsune_collider: CollisionShape3D = $KitsuneCollider
@onready var kitsune_anim_player: AnimationPlayer = $Kitsune/KitsuneVisuals/lp_fox/AnimationPlayer

# visual junk
@onready var double_jump_particles:GPUParticles3D = $DJ_PARTICLE
@onready var morphs:Node3D= $morphpart

# internal vars
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity_scale := 1.0 #modified at runtime by movement modes
var target_velocity := Vector3.ZERO
var target_direction := Vector3.ZERO
var sprint_multiplier:float = 1.0
@onready var anim_player:AnimationPlayer

# declare callable funcs
var current_jump_func: Callable
var current_attack_func: Callable
var current_dash_func: Callable
var current_sprint_func: Callable
var current_crouch_func: Callable
var current_interact_func: Callable
var move_speed: float

# declare changeable node refs
var visuals: Node3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_form_functions()
	swap_collider() # Added

func set_form_functions() -> void:
	if state_machine.current_form == state_machine.Form.HUMAN:
		current_jump_func = human.human_jump
		current_attack_func = human.human_attack
		current_dash_func = human.human_dash
		current_sprint_func = human.human_sprint
		current_crouch_func = human.human_crouch
		current_interact_func = human.human_interact
		visuals = human.get_node("HumanVisuals")
		move_speed = human.human_move_speed
		anim_player = human_anim_player
		human.visible = true
		kitsune.visible = false
	elif state_machine.current_form == state_machine.Form.KITSUNE:
		kitsune.visible = true
		human.visible = false
		current_jump_func = kitsune.kitsune_jump
		current_attack_func = kitsune.kitsune_attack
		current_dash_func = kitsune.kitsune_dash
		current_sprint_func = kitsune.kitsune_sprint
		current_crouch_func = kitsune.kitsune_crouch
		current_interact_func = kitsune.kitsune_interact
		visuals = kitsune.get_node("KitsuneVisuals")
		move_speed = kitsune.kitsune_move_speed
		anim_player = kitsune_anim_player
	print(anim_player)

func swap_collider():
	human_collider.disabled = kitsune.visible
	kitsune_collider.disabled = human.visible

func _physics_process(delta: float) -> void:
	if is_on_floor():
		set_gravity_scale(1.0)
	apply_gravity(delta)
	# reduce error
	if abs(velocity.x) < 0.01:
		velocity.x = 0
	if abs(velocity.z) < 0.01:
		velocity.z = 0
	move_and_slide()

func on_camera_rotate(amount:Vector2, delta:float) -> void:
	var sens = mouse_look_sensitivity
	if delta != 1: #detect if we are using a gamepad this frame, mouse delta=1
		sens = gamepad_look_sensitivity
		amount.x *= (-1)
	camera_pivot_yaw.rotate_y(amount.x * sens * delta)
	camera_pivot_pitch.rotate_x(amount.y * sens * delta)
	camera_pivot_pitch.rotation.x = clamp(camera_pivot_pitch.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func on_move(move_direction: Vector3, delta: float) -> void:
	var camera_forward: Vector3 = camera_pivot_pitch.global_transform.basis.z * -1
	camera_forward.y = 0
	camera_forward = camera_forward.normalized()
	var camera_right: Vector3 = camera_pivot_pitch.global_transform.basis.x
	camera_right.y = 0
	camera_right = camera_right.normalized()
	var relative_movement_direction := Vector3.ZERO
	relative_movement_direction = camera_forward * move_direction.z + camera_right * move_direction.x
	relative_movement_direction.y = 0
	relative_movement_direction = relative_movement_direction.normalized()
	target_direction = visuals.global_transform.basis.z * -1
	target_direction.y = 0
	target_direction = target_direction.normalized()
	
	
	if relative_movement_direction != Vector3.ZERO:
		var target_rotation: float = -atan2(relative_movement_direction.z, relative_movement_direction.x)
		target_rotation -= PI / 2.0
		visuals.rotation.y = lerp_angle(visuals.rotation.y, target_rotation, rotation_speed*delta)
	target_velocity = relative_movement_direction * move_speed * sprint_multiplier
	
	var accel:float
	if is_on_floor():
		if move_direction.length_squared() > 0.01:
			accel = acceleration
		else:
			accel = deceleration
	else:
		accel = air_deceleration
	velocity.x = lerp(velocity.x, target_velocity.x, accel * delta)
	velocity.z = lerp(velocity.z, target_velocity.z, accel * delta)

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

func interact() -> void:
	current_interact_func.call()

func swap_form(new_form:StateMachine.Form):
	# We already swapped the form in the state machine, now what does the character do with that?
	if new_form == state_machine.Form.KITSUNE:
		kitsune.visible = true
		human.visible = false
	else:
		human.visible = true
		kitsune.visible = false

	set_form_functions()
	swap_collider()

func set_gravity_scale(multiplier:float):
	gravity_scale = multiplier

func apply_gravity(delta:float):
	if not is_on_floor():
		velocity.y -= gravity * gravity_scale * delta
