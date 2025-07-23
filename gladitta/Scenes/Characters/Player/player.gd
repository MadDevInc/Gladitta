extends CharacterBody2D

@export var GRAVITY = 980
@export var TERMINAL_FALLING_VELOCITY = 200.0
@export var SPEED = 75.0
@export var JUMP_VELOCITY = -200.0

var sword_scene = load("res://Scenes/Characters/Sword/sword.tscn")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		#velocity.y = clamp(velocity.y, -INF, TERMINAL_FALLING_VELOCITY)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump"):
		velocity.y *= 0.5

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.play("idle")

	if direction == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.flip_h = true

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	if Input.is_action_just_pressed("attack"):
		var sword_instance = sword_scene.instantiate()
		get_parent().add_child(sword_instance)
		sword_instance.set_direction(direction)
		sword_instance.global_position.x = self.global_position.x
		sword_instance.global_position.y = self.global_position.y + 5

	move_and_slide()

func launch():
	pass
