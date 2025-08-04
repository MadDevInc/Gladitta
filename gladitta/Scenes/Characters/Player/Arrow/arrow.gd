extends CharacterBody2D

const SPEED = 200.0

var dir = Vector2()

var collision = null

func get_direction():
	return dir

func set_direction(new_dir):
	dir = new_dir
	self.look_at(global_position + dir)

func _physics_process(delta: float) -> void:
	if is_on_floor() or is_on_ceiling() or is_on_wall():
		velocity = Vector2.ZERO
	else:
		velocity = dir * SPEED

	move_and_slide()

func launch(direction):
	set_direction(direction)
