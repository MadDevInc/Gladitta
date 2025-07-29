extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Arrow") or body.is_in_group("Player"):
		body.launch(Vector2(0, -1))
		$AnimatedSprite2D.play("launch")
