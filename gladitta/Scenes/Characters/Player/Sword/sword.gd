extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DEACCELERATION = 0.2

var direction = Vector2()

func set_direction(new_direction):
	direction = new_direction
	velocity = direction * SPEED

func _physics_process(_delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, DEACCELERATION)

	move_and_slide()
