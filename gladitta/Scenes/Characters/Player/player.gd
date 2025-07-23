extends CharacterBody2D

@export var GRAVITY = 980
@export var TERMINAL_FALLING_VELOCITY = 200.0
@export var SPEED = 75.0
@export var JUMP_VELOCITY = -200.0

var sword_scene = load("res://Scenes/Characters/Player/Sword/sword.tscn")

var orientation = 1

func _ready() -> void:
	$Sword/Sprite2D.hide()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
		#velocity.y = clamp(velocity.y, -INF, TERMINAL_FALLING_VELOCITY)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	#if Input.is_action_just_released("jump"):
		#velocity.y *= 0.5

	if Input.is_action_pressed("move_right"):
		velocity.x = SPEED
		orientation = 1
		move_sword("right")
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = false
	elif Input.is_action_pressed("move_left"):
		velocity.x = -SPEED
		orientation = -1
		move_sword("left")
		$AnimatedSprite2D.play("run")
		$AnimatedSprite2D.flip_h = true
	elif Input.is_action_pressed("move_down"):
		#velocity.x = 0.0
		move_sword("down")
	elif Input.is_action_pressed("move_up"):
		#velocity.x = 0.0
		move_sword("up")
	else:
		velocity.x = 0.0
		if orientation == 1:
			move_sword("right")
		else:
			move_sword("left")
		$AnimatedSprite2D.play("idle")

	if Input.is_action_just_pressed("attack") and !$Sword/AnimationPlayer.is_playing():
		$Sword/AnimationPlayer.play("attack")

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	move_and_slide()

func move_sword(direction):
	match direction:
		"right":
			$Sword.position = Vector2(8, 0)
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = 0
		"left":
			$Sword.position = Vector2(-8, 0)
			$Sword/Sprite2D.flip_h = true
			$Sword/Sprite2D.rotation_degrees = 0
		"down":
			$Sword.position = Vector2(0, 8)
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = 90
		"up":
			$Sword.position = Vector2(0, -8)
			$Sword/Sprite2D.flip_h = false
			$Sword/Sprite2D.rotation_degrees = -90

func launch(direction):
	velocity = direction * 1000
 
func _on_sword_body_entered(body: Node2D) -> void:
	if $Sword/Sprite2D.rotation_degrees == 90:
		launch(Vector2(0, -1))
