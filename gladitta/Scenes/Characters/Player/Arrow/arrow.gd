extends CharacterBody2D

const SPEED = 400.0

var dir = Vector2()

var collision = null

func get_direction():
	return dir

func set_direction(new_dir):
	dir = new_dir
	self.look_at(dir)

func _process(delta: float) -> void:
	velocity = dir * SPEED * delta
	collision = move_and_collide(velocity)
	if collision != null:
		if collision.get_collider() is TileMapLayer:
			process_mode = PROCESS_MODE_DISABLED
			velocity = Vector2.ZERO
			set_process(false)
