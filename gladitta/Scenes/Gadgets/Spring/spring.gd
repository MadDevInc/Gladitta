extends Area2D

var arrow_scene = load("res://Scenes/Characters/Player/Arrow/arrow.tscn")

@onready var direction = $Marker2D.global_position - self.global_position 

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		body.launch(-direction)
	if body.is_in_group("Arrow"):
		body.get_parent().queue_free()
		var arrow_instance = arrow_scene.instantiate()
		get_parent().get_node("Arrows").call_deferred("add_child", arrow_instance)
		arrow_instance.global_position = self.global_position
		arrow_instance.set_direction(direction)
	$AnimatedSprite2D.play("expand")
