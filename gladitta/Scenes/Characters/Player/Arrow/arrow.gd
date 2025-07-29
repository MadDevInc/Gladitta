extends CharacterBody2D

const SPEED = 400.0

var dir = Vector2()

var collision = null

func get_direction():
	return dir

func set_direction(new_dir):
	dir = new_dir
	self.look_at(Vector2(global_position.x, global_position.y + dir.y))

func _process(delta: float) -> void:
	print(velocity)
	velocity = dir * SPEED * delta
	collision = move_and_collide(velocity)
	if collision != null:
		if collision.get_collider().is_in_group("Solid"):
			#process_mode = PROCESS_MODE_DISABLED
			velocity = Vector2.ZERO
			#set_process(false)

func launch(direction):
	velocity = Vector2.ZERO
	set_direction(direction)
