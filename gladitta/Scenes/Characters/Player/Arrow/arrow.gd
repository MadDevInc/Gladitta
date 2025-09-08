extends CharacterBody2D

const SPEED = 200.0

var dir = Vector2()

var _is_traveling = true

func _ready() -> void:
	get_parent().get_node("Player").death.connect(_on_player_death)

func get_direction():
	return dir

func set_direction(new_dir):
	dir = new_dir
	self.look_at(global_position + dir)

func _physics_process(_delta: float) -> void:
	$Label.text = "is_traveling: " + "\n" + str(_is_traveling) + "\nvelocity: " + str(velocity)
	if is_on_floor() or is_on_ceiling() or is_on_wall():
		velocity = Vector2.ZERO
	else:
		velocity = dir * SPEED

	if get_last_slide_collision() != null:
		if get_last_slide_collision().get_collider() is TileMapLayer:
			_is_traveling = false

	move_and_slide()

func launch(direction):
	set_direction(direction)

func _on_player_death():
	self.queue_free()

func is_traveling():
	return _is_traveling
