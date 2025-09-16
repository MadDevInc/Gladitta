extends CharacterBody2D

enum Directions {right = 1, left = -1}

const SPEED = 15.0
const GRAVITY = 800.0

var flying : bool
var moving : bool
var direction : Directions = Directions.right

@onready var player = get_parent().get_parent().get_parent().get_node("Player")

var death_particles_scene = preload("res://Scenes/Characters/Enemy/Enemy/bat_death_particles.tscn")

func _physics_process(delta: float) -> void:
	if not is_on_floor() and !flying:
		velocity.y += GRAVITY * delta

	$AnimatedSprite2D.play("idle")

	if moving:
		velocity.x = SPEED * direction

		if direction == Directions.right:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		if player.global_position.x > self.global_position.x:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

	move_and_slide()

func launch(dir):
	velocity.y = dir.y * -300
	velocity.x = dir.x * -250

func _on_r_wall_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and body != self:
		switch_directions()

func _on_l_wall_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and body != self:
		switch_directions()

func switch_directions():
	if direction == Directions.right:
		direction = Directions.left
	else:
		direction = Directions.right

func _on_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		#kill()
		pass

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Arrow"):
		if body.name == "Tip":
			if body.get_parent().is_traveling():
				kill()
		else:
			if body.is_traveling():
				kill()
	if body.is_in_group("Boomerang"):
		kill()

func kill():
	var death_particles_instance = death_particles_scene.instantiate()
	get_parent().add_child(death_particles_instance)
	death_particles_instance.global_position = global_position
	queue_free()
