extends CharacterBody2D

signal death

const GRAVITY = 800.0
const MAX_velocity = 75.0
const JUMP_FORCE = -200.0

var MAX_JUMP_BUFFER = 5
var jump_buffer = 0

var speed = Vector2()
var applied_forces = Vector2()

var direction = Vector2(1, 0)

var arrow_scene = preload("res://Scenes/Characters/Player/Arrow/arrow.tscn")

@onready var initial_position = self.global_position

func _physics_process(delta: float) -> void:
	$Label.text = "v5el: " + str(velocity).pad_decimals(0)
	$Label.text += "\nvelocity: " + str(velocity).pad_decimals(0)
	$Label.text += "\napplied: " + str(applied_forces).pad_decimals(0)
	$Label.text += "\njbuff: " + str(jump_buffer).pad_decimals(0)
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	else:
		if jump_buffer > 0:
			velocity.y = JUMP_FORCE
			jump_buffer = 0

		if velocity.x != 0.0:
			$AnimatedSprite2D.play("run")
		else:
			$AnimatedSprite2D.play("idle")
		applied_forces = Vector2.ZERO

	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
			jump_buffer = 0
		else:
			jump_buffer = MAX_JUMP_BUFFER

	if jump_buffer > 0:
		jump_buffer -= 1

	if Input.is_action_just_pressed("attack"):
		$Sword/AnimationPlayer.play("attack")
	
	if Input.is_action_pressed("shoot"):
		Engine.time_scale = 0.05
		$DirectionPivot.show()
	if Input.is_action_just_released("shoot"):
		Engine.time_scale = 1.0
		$DirectionPivot.hide()
		instantiate_arrow()

	if Input.is_action_pressed("move_right") and applied_forces.length() < 1.0:
		velocity.x = MAX_velocity
		move_sword("right")
		direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left") and applied_forces.length() < 1.0:
		velocity.x = -MAX_velocity
		move_sword("left")
		direction = Vector2(-1, 0)
	else:
		velocity.x = 0.0
		

	if Input.is_action_pressed("move_down"):
		move_sword("down")
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		move_sword("up")
		direction = Vector2(0, -1)

	if Input.is_action_pressed("move_down") and Input.is_action_pressed("move_left"):
		direction = Vector2(-1, 1)
	elif Input.is_action_pressed("move_down") and Input.is_action_pressed("move_right"):
		direction = Vector2(1, 1)
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_left"):
		direction = Vector2(-1, -1)
	elif Input.is_action_pressed("move_up") and Input.is_action_pressed("move_right"):
		direction = Vector2(1, -1)

	if direction.x == 1:
		$AnimatedSprite2D.flip_h = false
	elif direction.x == -1:
		$AnimatedSprite2D.flip_h = true

	$DirectionPivot.rotation_degrees = rad_to_deg(direction.angle())

	if not is_on_floor():
		$AnimatedSprite2D.play("jump")

	velocity += applied_forces
	applied_forces = lerp(applied_forces, Vector2.ZERO, 0.05)

	move_and_slide()

func _on_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		kill()

func launch(dir):
	velocity.y = dir.y * -250
	applied_forces.x = dir.x * -200

func _on_sword_body_entered(body: Node2D) -> void:
	if body != self:
		if $Sword.position.y == 0 and !is_on_floor():
			launch(Vector2($Sword.position.x/8, 0.25))
		else:
			launch($Sword.position/8)

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
	if direction.y == 1 and is_on_floor():
		return

	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.set_direction(direction)
	get_parent().add_child(arrow_instance)
	arrow_instance.global_position = $DirectionPivot/Bow.global_position

	if direction.y == 0.0:
		launch(Vector2(direction.x, 0.25))
	elif direction.y == 1 and direction.x == 0:
		launch(direction * 0.85)
	else:
		launch(direction * 0.75)

func kill():
	self.global_position = initial_position
	death.emit()
