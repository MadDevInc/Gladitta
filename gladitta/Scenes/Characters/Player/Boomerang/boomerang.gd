extends CharacterBody2D

const SPEED = 75.0

var dir

func set_direction(new_dir):
	print(new_dir)
	dir = new_dir

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED

	move_and_slide()

func _on_horizontal_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid"):
		dir.x = -dir.x

func _on_vertical_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid"):
		dir.y = -dir.y
