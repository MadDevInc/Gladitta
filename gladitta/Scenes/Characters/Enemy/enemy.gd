extends CharacterBody2D

enum Directions {right = 1, left = -1}

const SPEED = 35.0
const GRAVITY = 980

@export var moving : bool
@export var direction : Directions = Directions.right

var is_switching = true

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if moving:
		velocity.x = SPEED * direction

		if $SlopeDetector.get_collider() == null and !is_switching:
			is_switching = true
			if direction == Directions.right:
				direction = Directions.left
			else:
				direction = Directions.right

		if $SlopeDetector.get_collider() != null and is_switching:
			is_switching = false

	move_and_slide()

func _on_arrow_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Projectile"):
		self.queue_free()

func _on_arrow_detector_area_entered(area: Area2D) -> void:
	if area.is_in_group("Sword"):
		pass
