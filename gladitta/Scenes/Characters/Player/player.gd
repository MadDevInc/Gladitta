extends CharacterBody2D

const GRAVITY = 980
const TERMINAL_FALLING_VELOCITY = 200.0
const MAX_SPEED = 75.0
const ACCELERATION = 25.0
const JUMP_VELOCITY = -200.0
const DEACCELERATION = 1.0

var sword_scene = load("res://Scenes/Characters/Player/Sword/sword.tscn")

var direction = Vector2(1, 0)

var horizontal_forces = 0.0

func _ready() -> void:
	$Sword/Sprite2D.hide()

func _physics_process(delta: float) -> void:
	$Label.text = "vel: " + str(velocity)

#add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

#handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

#handle movement
	if Input.is_action_pressed("move_right"):
		velocity.x = MAX_SPEED
		move_sword("right")
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false

		direction = Vector2(1, 0)
		$DirectionPivot/Sprite2D.flip_v = false

	elif Input.is_action_pressed("move_left"):
		velocity.x = -MAX_SPEED
		move_sword("left")
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true

		direction = Vector2(-1, 0)
		$DirectionPivot/Sprite2D.flip_v = true

	else:
		velocity.x = 0.0
		if !$AnimatedSprite2D.flip_h:
			move_sword("right")
		else:
			move_sword("left")
		$AnimatedSprite2D.play("idle")

#up, down and combined directions must be independent from movement
	if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"):
		direction = Vector2(0.5, 0.5)
		$DirectionPivot/Sprite2D.flip_v = false

	elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_up"):
		direction = Vector2(0.5, -0.5)
		$DirectionPivot/Sprite2D.flip_v = false

	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_up"):
		direction = Vector2(-0.5, -0.5)
		$DirectionPivot/Sprite2D.flip_v = true

	elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_down"):
		direction = Vector2(-0.5, 0.5)
		$DirectionPivot/Sprite2D.flip_v = true

	elif Input.is_action_pressed("move_down"):
		move_sword("down")

		direction = Vector2(0, 1)
		$DirectionPivot/Sprite2D.flip_v = false

	elif Input.is_action_pressed("move_up"):
		move_sword("up")

		direction = Vector2(0, -1)
		$DirectionPivot/Sprite2D.flip_v = false

	$Sword.position = direction * 8
	$DirectionPivot.rotation_degrees = rad_to_deg(direction.angle())

	if Input.is_action_just_pressed("attack") and !$Sword/AnimationPlayer.is_playing():
		$Sword/AnimationPlayer.play("attack")

	if Input.is_action_just_pressed("shoot"):
		Engine.time_scale = 0.1
		$DirectionPivot.show()
	if Input.is_action_just_released("shoot"):
		$DirectionPivot.hide()
		Engine.time_scale = 1.0

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	velocity.x += horizontal_forces
	horizontal_forces = lerp(horizontal_forces, 0.0, 0.3)

	move_and_slide()

func move_sword(new_direction):
	if $Sword/AnimationPlayer.is_playing():
		return

	match new_direction:
		"right":
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = 0
			$Sword/CollisionShape2D.rotation_degrees = 0
		"left":
			$Sword/Sprite2D.flip_h = true
			$Sword/Sprite2D.rotation_degrees = 0
			$Sword/CollisionShape2D.rotation_degrees = 0
		"down":
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = 90
			$Sword/CollisionShape2D.rotation_degrees = 90
		"up":
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = -90
			$Sword/CollisionShape2D.rotation_degrees = 90

func launch(dir):
	velocity.y = dir.y * 250
	horizontal_forces = dir.x * 350
 
func _on_sword_body_entered(body: Node2D) -> void:
	if body != self:
		launch(-direction)
