extends Node3D

@onready var player = $Player

func _physics_process(delta: float) -> void:
	if player.position.y <= -20.0:
		player.position = Vector3.ZERO
