extends CharacterBody2D

const SPEED = 400

var dir = Vector2()

var collision = null

func set_direction(new_dir):
	dir = new_dir
	self.look_at(dir)

func _process(delta: float) -> void:
	velocity = dir * SPEED * delta
	collision = move_and_collide(velocity)
	if collision != null:
		set_process(false)
