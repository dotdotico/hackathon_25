# input_handler.gd
extends Node

signal move(move_direction:Vector3, delta:float)
signal look(look_direction:Vector3, delta:float)
signal rotate_camera_horizontal(amount:float)
signal rotate_camera_vertical(amount:float)
signal action_jump()
signal action_crouch()
signal action_dash()
signal action_sprint()
signal action_one()
signal action_two()
signal action_form_swap()

func _physics_process(delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_backward", "move_forward")
	if input_vector != Vector2.ZERO:
		var move_direction = Vector3(input_vector.x, 0, input_vector.y)
		emit_signal("move", move_direction.normalized(), delta)
	
	if Input.is_action_just_pressed("action_jump"):
		emit_signal("action_jump")
	if Input.is_action_just_pressed("action_crouch"):
		emit_signal("action_crouch")
	if Input.is_action_just_pressed("action_dash"):
		emit_signal("action_dash")
	if Input.is_action_just_pressed("action_sprint"):
		emit_signal("action_sprint")
	if Input.is_action_just_pressed("action_one"):
		emit_signal("action_one")
	if Input.is_action_just_pressed("action_two"):
		emit_signal("action_two")
	if Input.is_action_just_pressed("action_form_swap"):
		emit_signal("action_form_swap")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		emit_signal("rotate_camera_horizontal", -event.relative.x)
		emit_signal("rotate_camera_vertical", -event.relative.y)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
