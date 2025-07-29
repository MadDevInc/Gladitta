extends CharacterBody2D

const GRAVITY = 800.0
const TERMINAL_FALLING_VELOCITY = 150.0
const SPEED = 250.0

var triggered = false

func _physics_process(delta: float) -> void:
	$Label.text = str(triggered)
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		velocity.y = clamp(velocity.y, -INF, TERMINAL_FALLING_VELOCITY)

	velocity.x = lerp(velocity.x, 0.0, 0.05)

	move_and_slide()

func launch(direction):
	velocity.y = direction.y * 200
	velocity.x = direction.x * SPEED

func _on_detector_body_entered(body: Node2D) -> void:
	if body != self:
		if body.is_in_group("Arrow"):
			if !triggered:
				launch(body.get_direction())
			else:
				explode()
		triggered = true

func explode():
	for body in $Detector.get_overlapping_bodies():
		if body is not TileMapLayer and body != self:
			print(body)
			body.launch( (body.global_position - self.global_position).normalized() )
	await get_tree().create_timer(0.2).timeout
	self.queue_free()
