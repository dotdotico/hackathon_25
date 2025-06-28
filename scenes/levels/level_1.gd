extends Node3D

@onready var player = $Player

func _physics_process(delta: float) -> void:
	if player.position.y <= -20.0:
		player.position = Vector3.ZERO

@onready var flag: StaticBody3D = $flag

func _ready():
	pass

func _on_win_signal():
	pass
