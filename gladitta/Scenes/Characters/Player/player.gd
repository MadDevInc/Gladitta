extends CharacterBody2D

enum states {WALKING, AIMING}

const GRAVITY = 980
const TERMINAL_FALLING_VELOCITY = 200.0
const MAX_SPEED = 75.0
const ACCELERATION = 25.0
const JUMP_VELOCITY = -200.0
const DEACCELERATION = 1.0

var arrow_scene = preload("res://Scenes/Characters/Player/Arrow/arrow.tscn")

var current_state = states.WALKING

var direction = Vector2(1, 0)

var horizontal_forces = 0.0

func _ready() -> void:
	$Sword/Sprite2D.hide()

func _physics_process(delta: float) -> void:
	$Label.text = "vel: " + str(velocity)
	$Label.text += "st: " + str(current_state)

#add gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta

#handle jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("attack") and !$Sword/AnimationPlayer.is_playing():
		$Sword/AnimationPlayer.play("attack")

	if Input.is_action_pressed("shoot"):
		current_state = states.AIMING
		if not is_on_floor():
			Engine.time_scale = 0.1
		else:
			velocity.x = 0.0
			$AnimatedSprite2D.play("idle")
		$DirectionPivot.show()
	if Input.is_action_just_released("shoot"):
		instantiate_arrow()

		current_state = states.WALKING
		$DirectionPivot.hide()
		Engine.time_scale = 1.0

	if current_state == states.WALKING:
		if Input.is_action_pressed("move_right"):
			velocity.x = MAX_SPEED
			move_sword("right")
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = false
			direction = Vector2(1, 0)

		elif Input.is_action_pressed("move_left"):
			velocity.x = -MAX_SPEED
			move_sword("left")
			$AnimatedSprite2D.play("run")
			$AnimatedSprite2D.flip_h = true
			direction = Vector2(-1, 0)

		else:
			velocity.x = 0.0
			if !$AnimatedSprite2D.flip_h:
				move_sword("right")
			else:
				move_sword("left")

		if Input.is_action_pressed("move_down"):
			move_sword("down")
			#velocity.x = 0.0

		elif Input.is_action_pressed("move_up"):
			move_sword("up")
			#velocity.x = 0.0

		if velocity.x == 0:
			$AnimatedSprite2D.play("idle")

	elif current_state == states.AIMING:
		if Input.is_action_pressed("move_right") and Input.is_action_pressed("move_down"):
			direction = Vector2(1.0, 1.0)
			$DirectionPivot/Bow.flip_v = false

		elif Input.is_action_pressed("move_right") and Input.is_action_pressed("move_up"):
			direction = Vector2(1.0, -1.0)
			$DirectionPivot/Bow.flip_v = false

		elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_up"):
			direction = Vector2(-1.0, -1.0)
			$DirectionPivot/Bow.flip_v = true

		elif Input.is_action_pressed("move_left") and Input.is_action_pressed("move_down"):
			direction = Vector2(-1.0, 1.0)
			$DirectionPivot/Bow.flip_v = true

		elif Input.is_action_pressed("move_down"):
			direction = Vector2(0, 1)
			$DirectionPivot/Bow.flip_v = false

		elif Input.is_action_pressed("move_up"):
			direction = Vector2(0, -1)
			$DirectionPivot/Bow.flip_v = false

		elif Input.is_action_pressed("move_left"):
			direction = Vector2(-1, 0)
			$DirectionPivot/Bow.flip_v = false

		elif Input.is_action_pressed("move_right"):
			direction = Vector2(1, 0)
			$DirectionPivot/Bow.flip_v = false

		$DirectionPivot.rotation_degrees = rad_to_deg(direction.angle())

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	velocity.x += horizontal_forces
	horizontal_forces = lerp(horizontal_forces, 0.0, 0.2)

	move_and_slide()

func move_sword(new_direction):
	if $Sword/AnimationPlayer.is_playing():
		return

	match new_direction:
		"right":
			$Sword.position = Vector2(8, 0)
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = 0
			$Sword/CollisionShape2D.rotation_degrees = 0
		"left":
			$Sword.position = Vector2(-8, 0)
			$Sword/Sprite2D.flip_h = true
			$Sword/Sprite2D.rotation_degrees = 0
			$Sword/CollisionShape2D.rotation_degrees = 0
		"down":
			$Sword.position = Vector2(0, 8)
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = 90
			$Sword/CollisionShape2D.rotation_degrees = 90
		"up":
			$Sword.position = Vector2(0, -8)
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = -90
			$Sword/CollisionShape2D.rotation_degrees = 90

func instantiate_arrow():
	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.set_direction(direction)
	get_parent().add_child(arrow_instance)
	arrow_instance.global_position = $DirectionPivot/Bow.global_position

	launch(-direction)

func launch(dir):
	velocity.y = dir.y * 250
	horizontal_forces = dir.x * 400
 
func _on_sword_body_entered(body: Node2D) -> void:
	if body != self:
		launch(-$Sword.position/8)
