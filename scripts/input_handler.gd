# input_handler.gd
extends Node
class_name InputHandler

signal move(move_direction:Vector3, delta:float)
signal rotate_camera(amount:Vector2, delta:float)
signal action_jump()
signal action_crouch()
signal action_dash()
signal action_sprint()
signal action_interact()
signal action_attack()
signal action_form_swap()

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	if input_vector != Vector2.ZERO:
		var move_direction = Vector3(input_vector.x, 0, input_vector.y)
		emit_signal("move", move_direction.normalized())

	if Input.is_action_just_pressed("action_jump"):
		emit_signal("action_jump")
	if Input.is_action_just_pressed("action_crouch"):
		emit_signal("action_crouch")
	if Input.is_action_just_pressed("action_dash"):
		emit_signal("action_dash")
	if Input.is_action_just_pressed("action_sprint"):
		emit_signal("action_sprint")
	if Input.is_action_just_pressed("action_interact"):
		emit_signal("action_interact")
	if Input.is_action_just_pressed("action_form_swap"):
		emit_signal("action_form_swap")

func _process(delta: float) -> void: #called every single possible frame, good for cameras
	var input_vector = Input.get_vector("look_left", "look_right", "look_down", "look_up")
	if input_vector != Vector2.ZERO:
		emit_signal("rotate_camera", input_vector.normalized(), delta)
		print(input_vector)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and (Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		emit_signal("rotate_camera", -event.relative, 1.0)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
