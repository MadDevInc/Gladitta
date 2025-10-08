class_name Boomerang
extends CharacterBody2D

const SPEED = 75.0

var dir = Vector2(1, -1)

var shooter

var death_particles_scene = preload("res://Scenes/Characters/Player/Boomerang/DeathParticles/boomer_death_particles.tscn")

func _ready() -> void:
	get_parent().get_node("Player").death.connect(_on_player_death)

func set_shooter(node):
	shooter = node
	await get_tree().create_timer(0.2).timeout
	shooter = null

func set_direction(new_dir):
	
	dir = new_dir

func _physics_process(_delta: float) -> void:
	#print(velocity)
	velocity = dir * SPEED

	if velocity.x > 0 or velocity.y < 0:
		$AnimationPlayer.play("spin_clockwise")
	else:
		$AnimationPlayer.play("spin_counterclockwise")

	$Tip.position = 6 * velocity.normalized()

	move_and_slide()

func _on_horizontal_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and !body.is_in_group("Enemy") and body != self:
		dir.x = -dir.x
	if body.is_in_group("Solid") and body is TileMapLayer:
		shooter = null
		#reset_collider()

func _on_vertical_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and !body.is_in_group("Enemy") and body != self:
		dir.y = -dir.y
	if body.is_in_group("Solid") and body is TileMapLayer:
		shooter = null
		#reset_collider()

func kill():
	var death_particles_instance = death_particles_scene.instantiate()
	get_parent().add_child(death_particles_instance)
	death_particles_instance.global_position = global_position
	self.queue_free()

func reset_collider():
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.05).timeout
	$CollisionShape2D.set_deferred("disabled", false)

func _on_player_death():
	self.queue_free()

func _on_arrow_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Arrow"):
		if body.name == "Tip":
			if body.get_parent().is_traveling():
				kill()
		else:
			if body.is_traveling():
				kill()
