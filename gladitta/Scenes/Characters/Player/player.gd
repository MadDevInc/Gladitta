extends CharacterBody2D

signal death

const GRAVITY = 800.0
const MAX_velocity = 75.0
const JUMP_FORCE = -200.0
const MAX_DASH_FRAMES = 7

var MAX_JUMP_BUFFER = 5
var jump_buffer = 0

var speed = Vector2()
var applied_forces = Vector2()

var direction = Vector2(1, 0)

var shoot_direction = Vector2()

var arrow_scene = preload("res://Scenes/Characters/Player/Arrow/arrow.tscn")

var primed_dash = false
var dashing = 0
var was_dashing = false

@export var max_arrows = 3

@onready var initial_position = self.global_position
@onready var arrow_count = max_arrows

func _physics_process(delta: float) -> void:
	$Label.text = "direction" + str(direction).pad_decimals(0)
	$Label.text += "\nvelocity" + str(velocity).pad_decimals(0)
	$Label.text += "\napplied" + str(applied_forces)
	if Input.is_action_just_pressed("reset"):
		kill()

	if dashing <= 0:
		if Input.is_action_pressed("dash_trigger"):
			if Input.is_action_pressed("jump"):
				primed_dash = true
				Engine.time_scale = 0.05
				$DirectionPivot.show()
				$DirectionPivot/Bow.hide()
		if Input.is_action_just_released("dash_trigger") and primed_dash:
			Engine.time_scale = 1.0
			$DirectionPivot.hide()
			dashing = MAX_DASH_FRAMES
			primed_dash = false
		elif Input.is_action_just_released("jump") and primed_dash:
			Engine.time_scale = 1.0
			$DirectionPivot.hide()
			dashing = MAX_DASH_FRAMES
			primed_dash = false

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

		if Input.is_action_just_pressed("jump") and !Input.is_action_pressed("dash_trigger"):
			if is_on_floor():
				velocity.y = JUMP_FORCE
				jump_buffer = 0
			else:
				jump_buffer = MAX_JUMP_BUFFER

		if jump_buffer > 0:
			jump_buffer -= 1

		if Input.is_action_just_pressed("attack"):
			$Sword/AnimationPlayer.play("attack")
		
		if Input.is_action_pressed("shoot") and arrow_count > 0:
			Engine.time_scale = 0.05
			$DirectionPivot.show()
			$DirectionPivot/Bow.show()
		if Input.is_action_just_released("shoot") and arrow_count > 0:
			shoot_direction = direction
			Engine.time_scale = 1.0
			$DirectionPivot.hide()
			instantiate_arrow()

		if Input.is_action_pressed("move_right"):
			move_sword("right")
			direction = Vector2(1, 0)
		elif Input.is_action_pressed("move_left"):
			move_sword("left")
			direction = Vector2(-1, 0)
		elif !Input.is_action_pressed("shoot"):
			if !$AnimatedSprite2D.flip_h:
				direction = Vector2(1, 0)
				move_sword("right")
			else:
				direction = Vector2(-1, 0)
				move_sword("left")

		if Input.is_action_pressed("move_right") and applied_forces.length() < 1.0:
			velocity.x = MAX_velocity
		elif Input.is_action_pressed("move_left") and applied_forces.length() < 1.0:
			velocity.x = -MAX_velocity
		else:
			velocity.x = 0.0
			if was_dashing:
				velocity.y *= 0.25
		
		if velocity.y > 0:
			was_dashing = false

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
	else:
		applied_forces = Vector2.ZERO
		if direction.x == 0 or direction.y == 0:
			velocity = direction * 250
		else:
			velocity = direction * 0.5 * 250
		dashing -= 1
		was_dashing = true

	move_and_slide()

func launch(dir):
	velocity.y = dir.y * -300
	applied_forces.x = dir.x * -250

func _on_sword_body_entered(body: Node2D) -> void:
	if body != self:
		if $Sword.position.y == 0 and is_on_floor():
			return

		if $Sword.position.y == 0 and !is_on_floor():
			launch(Vector2($Sword.position.x/8, 0.25))
		else:
			launch(Vector2($Sword.position.x/8, 0.875))

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
	if shoot_direction.y == 1 and is_on_floor():
		return

	arrow_count -= 1

	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.set_direction(shoot_direction)
	get_parent().get_node("Arrows").add_child(arrow_instance)
	arrow_instance.global_position = $DirectionPivot/Bow.global_position

	if shoot_direction.y == 0.0:
		launch(Vector2(shoot_direction.x, 0.25))
	elif shoot_direction.y == 1 and shoot_direction.x == 0:
		launch(shoot_direction * 0.85)
	else:
		launch(shoot_direction * 0.75)

func kill():
	self.global_position = initial_position
	arrow_count = max_arrows
	$AnimatedSprite2D.flip_h = false
	death.emit()

func get_arrow_count():
	return arrow_count

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		kill()
