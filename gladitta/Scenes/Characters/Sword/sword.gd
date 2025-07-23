extends CharacterBody2D

const SPEED = 300.0
const DEACCELERATION = 0.05

var dir

func set_direction(new_dir):
	dir = new_dir
	velocity.x = SPEED

func _physics_process(delta: float) -> void:
	velocity.x = lerp(velocity.x, 0.0, DEACCELERATION)

	move_and_slide()
