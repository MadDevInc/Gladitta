extends Area2D

var arrow_scene = preload("res://Scenes/Characters/Player/Arrow/arrow.tscn")
var boomerang_scene = preload("res://Scenes/Characters/Player/Boomerang/boomerang.tscn")

@onready var direction = ($Marker2D.global_position - self.global_position).normalized()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		body.launch(-direction)
	if body.is_in_group("Arrow"):
		if body.get_parent() is not CharacterBody2D:
			body.queue_free()
		else:
			body.get_parent().queue_free()
		var arrow_instance = arrow_scene.instantiate()
		get_parent().call_deferred("add_child", arrow_instance)
		arrow_instance.global_position = $Marker2D.global_position
		arrow_instance.set_direction(direction)
	if body.is_in_group("Boomerang"):
		if body.get_parent() is not CharacterBody2D:
			body.queue_free()
		else:
			body.get_parent().queue_free()
		var boomerang_instance = boomerang_scene.instantiate()
		get_parent().call_deferred("add_child", boomerang_instance)
		boomerang_instance.global_position = $Marker2D.global_position
		boomerang_instance.set_direction(direction)
	$AnimatedSprite2D.play("expand")
