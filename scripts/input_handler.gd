# Input Handler
extends Node

signal move(move_direction:Vector3)
signal rotate_camera_horizontal(amount:float)
signal rotate_camera_vertical(amount:float)
signal action_jump()
signal action_crouch()
signal action_dash()
signal action_one()
signal action_two()

func _process(_delta):
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
	if Input.is_action_just_pressed("action_one"):
		emit_signal("action_one")
	if Input.is_action_just_pressed("action_two"):
		emit_signal("action_two")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		emit_signal("rotate_camera_horizontal", -event.relative.x)
		emit_signal("rotate_camera_vertical", -event.relative.y)

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
