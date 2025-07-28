extends CharacterBody2D

const GRAVITY = 800.0
const TERMINAL_FALLING_VELOCITY = 150.0
const SPEED = 400.0

var triggered = false

func _physics_process(delta: float) -> void:
	$Label.text = str(triggered)
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = clamp(velocity.y, -INF, TERMINAL_FALLING_VELOCITY)

	velocity.x = lerp(velocity.x, 0.0, 0.05)

	if get_last_slide_collision() != null:
		triggered = true

	move_and_slide()

func launch(direction):
	print(direction)
	velocity = direction * SPEED

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Arrow"):
		if !triggered:
			launch(body.get_direction())
		else:
			explode()
		body.queue_free()

func explode():
	self.queue_free()
