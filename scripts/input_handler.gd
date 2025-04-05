# Input Handler
extends Node

signal move(dir:Vector2)
signal action_jump()
signal action_crouch()
signal action_dash()
signal action_one()
signal action_two()

func _process(_delta):
	var input_vector = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	emit_signal("move", input_vector)
	
	if Input.is_action_just_pressed("jump"):
		emit_signal("action_jump")
	
	if Input.is_action_just_pressed("crouch"):
		emit_signal("action_crouch")
	
	if Input.is_action_just_pressed("dash"):
		emit_signal("action_dash")
	
	if Input.is_action_just_pressed("action_one"):
		emit_signal("action_one")
	
	if Input.is_action_just_pressed("action_two"):
		emit_signal("action_two")
