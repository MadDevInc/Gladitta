extends CharacterBody2D

const SPEED = 75.0

var dir

var shooter

func _ready() -> void:
	get_parent().get_node("Player").death.connect(_on_player_death)

func set_shooter(node):
	shooter = node
	await get_tree().create_timer(0.2).timeout
	shooter = null

func set_direction(new_dir):
	dir = new_dir

func _physics_process(_delta: float) -> void:
	velocity = dir * SPEED

	if velocity.x > 0 or velocity.y < 0:
		$AnimationPlayer.play("spin_clockwise")
	else:
		$AnimationPlayer.play("spin_counterclockwise")

	$Tip.position = 6 * velocity.normalized()

	move_and_slide()

func _on_horizontal_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and !body.is_in_group("Enemy"):
		dir.x = -dir.x
	if body.is_in_group("Solid") and body is TileMapLayer:
		shooter = null
		reset_collider()

func _on_vertical_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and !body.is_in_group("Enemy"):
		dir.y = -dir.y
	if body.is_in_group("Solid") and body is TileMapLayer:
		shooter = null
		reset_collider()

func reset_collider():
	$CollisionShape2D.set_deferred("disabled", true)
	await get_tree().create_timer(0.05).timeout
	$CollisionShape2D.set_deferred("disabled", false)

func _on_player_death():
	self.queue_free()
