# state.gd
extends Node
class_name State

# needed vars by each state
var state_machine: StateMachine
var character: GameCharacter
var anim_player: AnimationPlayer

# basic functions
func enter() -> void:
	pass

func handle_input(_event: InputEvent) -> void:
	pass

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	pass

func transition_to(target_state_key: StringName) -> void:
	if state_machine:
		state_machine.transition_to(target_state_key)
	else:
		printerr("No StateMachine found")
