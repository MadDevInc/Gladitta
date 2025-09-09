extends CharacterBody2D

const SPEED = 70.0

var dir

func _ready() -> void:
	get_parent().get_node("Player").death.connect(_on_player_death)

func set_direction(new_dir):
	dir = new_dir

func _physics_process(_delta: float) -> void:
	velocity = dir * SPEED

	if velocity.x > 0 or velocity.y < 0:
		$AnimationPlayer.play("spin_clockwise")
	else:
		$AnimationPlayer.play("spin_counterclockwise")

	$Tip.position = 12 * velocity.normalized()

	move_and_slide()

func _on_horizontal_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and !body.is_in_group("Enemy"):
		dir.x = -dir.x

func _on_vertical_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Solid") and !body.is_in_group("Enemy"):
		dir.y = -dir.y

func _on_player_death():
	self.queue_free()
