extends CharacterBody2D

class_name Arrow

const SPEED = 200.0

var dir = Vector2()

var _is_traveling = true

var shooter = null

var death_particles_scene = preload("res://Scenes/Characters/Player/Arrow/DeathParticles/arrow_death_particles.tscn")

var arrow_scene = preload("res://Scenes/Characters/Player/Arrow/arrow.tscn")

func _ready() -> void:
	get_parent().get_node("Player").death.connect(_on_player_death)

func set_shooter(node):
	shooter = node
	await get_tree().create_timer(0.2).timeout
	shooter = null

func get_direction():
	return dir

func set_direction(new_dir):
	dir = new_dir
	self.look_at(global_position + dir)

func _physics_process(_delta: float) -> void:
	print(dir)
	if is_on_floor() or is_on_ceiling() or is_on_wall():
		velocity = Vector2.ZERO
	else:
		velocity = dir * SPEED

	if get_last_slide_collision() != null:
		var collider = get_last_slide_collision().get_collider()
		if collider is TileMapLayer:
			_is_traveling = false
			add_to_group("Solid")
			self.process_mode = Node.PROCESS_MODE_DISABLED
		
		if collider is Arrow:
			if collider.is_traveling():
				#print(str(self.dir + collider.dir) + "on arrow " + str(self))
				if (self.dir + collider.dir).length() < 0.1:
					var arrow_instance = arrow_scene.instantiate()
					get_parent().add_child(arrow_instance)
					if abs(dir.x) > 0.1 and abs(dir.y) > 0.1:
						if sign(dir.x) != sign(dir.y):
							arrow_instance.global_position = (self.global_position + collider.global_position)/2 + abs(dir) * sign(dir.x) * 10
							arrow_instance.set_direction(abs(dir) * sign(dir.x))
						elif sign(dir.x) == sign(dir.y):
							arrow_instance.global_position = (self.global_position + collider.global_position)/2 + Vector2(dir.x, dir.y * - 1) * 10
							arrow_instance.set_direction(Vector2(dir.x, dir.y * - 1))
					else:
						arrow_instance.global_position = (self.global_position + collider.global_position)/2 + Vector2(self.dir.y, self.dir.x) * 10
						arrow_instance.set_direction(Vector2(self.dir.y, self.dir.x))
					self.queue_free()
				#var death_particles_instance = death_particles_scene.instantiate()
				#get_parent().add_child(death_particles_instance)
				#death_particles_instance.global_position = self.global_position
				#get_last_slide_collision().get_collider().queue_free()

	move_and_slide()

func launch(direction):
	set_direction(direction)

func _on_player_death():
	self.queue_free()

func is_traveling():
	return _is_traveling
