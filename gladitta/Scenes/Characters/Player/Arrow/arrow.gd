extends CharacterBody2D

const SPEED = 400

var dir = Vector2()

func set_direction(new_dir):
	dir = new_dir
	self.look_at(dir)

func _physics_process(delta: float) -> void:
	velocity = dir * SPEED * delta

	var collision = move_and_collide(velocity)
	print(collision)
