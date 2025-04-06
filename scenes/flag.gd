extends StaticBody3D

@onready var col = $CollisionShape3D

func _on_body_entered(body: Node3D):
	emit_signal(&"Win")
