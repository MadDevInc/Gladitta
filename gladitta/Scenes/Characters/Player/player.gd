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

var boomerang_scene = preload("res://Scenes/Characters/Player/Boomerang/boomerang.tscn")

var dash_particle = preload("res://Scenes/Characters/Player/DashParticle/dash_particle.tscn")

var death_partcile_scene = preload("res://Scenes/Characters/Player/DeathParticle/player_death_particles.tscn")

var primed_dash = false
var dashing = 0
var was_dashing = false

var first_click = false
var double_click = false

var use_sword_once = false

@export var max_arrows = 2
@export var max_dashes = 1
@export var max_boomer = 1

@onready var initial_position = self.global_position
@onready var arrow_count = max_arrows
@onready var dash_count = max_dashes
@onready var boomer_count = max_boomer

func _physics_process(delta: float) -> void:
	$Label.text = "first_click: "  + str(first_click) + "\ndouble_click: " + str(double_click)
	if Input.is_action_just_pressed("reset"):
		kill()

	if dashing <= 0:
		if not is_on_floor():
			$AnimatedSprite2D.play("jump")
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

		if Input.is_action_pressed("dash_trigger"):
			if Input.is_action_pressed("jump") and dash_count > 0:
				primed_dash = true
				Engine.time_scale = 0.05
				$DirectionPivot.show()
				$DirectionPivot/Bow.hide()
				$DirectionPivot/Boomerang.hide()
		if Input.is_action_just_released("dash_trigger") and primed_dash and dash_count > 0:
			Engine.time_scale = 1.0
			$DirectionPivot.hide()
			dashing = MAX_DASH_FRAMES
			dash_count -= 1
			primed_dash = false
			get_parent().shake_camera()
		elif Input.is_action_just_released("jump") and primed_dash and dash_count > 0:
			Engine.time_scale = 1.0
			$DirectionPivot.hide()
			dashing = MAX_DASH_FRAMES
			dash_count -= 1
			primed_dash = false
			get_parent().shake_camera()

		if Input.is_action_just_pressed("jump") and !Input.is_action_pressed("dash_trigger"):
			if is_on_floor():
				velocity.y = JUMP_FORCE
				jump_buffer = 0
			else:
				jump_buffer = MAX_JUMP_BUFFER

		if jump_buffer > 0:
			jump_buffer -= 1

		if Input.is_action_just_pressed("boomerang"):
			if first_click and boomer_count > 0:
				double_click = true
			else:
				first_click = true
				$double_click.start(0.5)
		if double_click:
			$double_click.stop()
			Engine.time_scale = 0.05
			$DirectionPivot.show()
			$DirectionPivot/Bow.hide()
			$DirectionPivot/Boomerang.show()
		if Input.is_action_just_released("boomerang"):
			if double_click:
				first_click = false
				double_click = false
				shoot_direction = direction
				instantiate_boomerang()
			Engine.time_scale = 1.0
			$DirectionPivot.hide()
			$DirectionPivot/Boomerang.hide()

		if Input.is_action_just_pressed("attack"):
			$Sword/AnimationPlayer.play("attack")
		
		if Input.is_action_pressed("shoot") and arrow_count > 0:
			Engine.time_scale = 0.05
			$DirectionPivot.show()
			$DirectionPivot/Bow.show()
			$DirectionPivot/Boomerang.hide()
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
		var new_dash_particle = dash_particle.instantiate()
		get_parent().add_child(new_dash_particle)
		new_dash_particle.global_position = self.global_position
		new_dash_particle.flip_h = $AnimatedSprite2D.flip_h
		new_dash_particle.set_animation_and_frame($AnimatedSprite2D.animation, $AnimatedSprite2D.frame)

	move_and_slide()

func launch(dir):
	velocity.y = dir.y * -300
	applied_forces.x = dir.x * -250

func _on_sword_body_entered(body: Node2D) -> void:

	if body.is_in_group("Enemy"):
		body.kill()
		get_parent().shake_camera()
	if body != self:
		if $Sword.position.y == 0 and is_on_floor():
			return

		if !use_sword_once:
			if $Sword.position.y == 0 and !is_on_floor():
				use_sword_once = true
				launch(Vector2($Sword.position.x/8, 0.25))
			else:
				use_sword_once = true
				launch(Vector2($Sword.position.x/8, 0.875 * sign($Sword.position.y)))

func move_sword(new_direction):
	if $Sword/AnimationPlayer.is_playing():
		return

	match new_direction:
		"right":
			$Sword.position = Vector2(8, 0)
			$Sword.rotation_degrees = 0
		"left":
			$Sword.position = Vector2(-8, 0)
			$Sword.rotation_degrees = 180
		"down":
			$Sword.position = Vector2(0, 8)
			$Sword.rotation_degrees = 90
		"up":
			$Sword.position = Vector2(0, -8)
			$Sword.rotation_degrees = -90

func instantiate_arrow():
	if shoot_direction.y == 1 and is_on_floor():
		return

	get_parent().shake_camera()
	arrow_count -= 1

	var arrow_instance = arrow_scene.instantiate()
	arrow_instance.set_direction(shoot_direction)
	get_parent().add_child(arrow_instance)
	arrow_instance.set_shooter(self)
	arrow_instance.global_position = $DirectionPivot/Bow.global_position

	if shoot_direction.y == 0.0:
		launch(Vector2(shoot_direction.x, 0.25))
	elif shoot_direction.y == 1 and shoot_direction.x == 0:
		launch(shoot_direction * 0.85)
	else:
		launch(shoot_direction * 0.75)

func instantiate_boomerang():
	if shoot_direction.y == 1 and is_on_floor():
		return

	get_parent().shake_camera()
	boomer_count -= 1

	var boomerang_instance = boomerang_scene.instantiate()
	boomerang_instance.set_direction(direction)
	get_parent().add_child(boomerang_instance)
	boomerang_instance.set_shooter(self)
	boomerang_instance.global_position = $DirectionPivot/Boomerang.global_position

func kill():
	var death_particle_instance = death_partcile_scene.instantiate()
	get_parent().add_child(death_particle_instance)
	death_particle_instance.global_position = self.global_position
	self.global_position = initial_position
	arrow_count = max_arrows
	dash_count = max_dashes
	boomer_count = max_boomer
	$AnimatedSprite2D.flip_h = false
	Engine.time_scale = 1.0
	death.emit()

func get_arrow_count():
	return arrow_count

func get_boomer_count():
	return boomer_count

func get_dash_count():
	return dash_count

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		kill()
	if body.is_in_group("Arrow"):
		if body.shooter != self:
			if body.name == "Tip":
				if body.get_parent().is_traveling():
					kill()
			else:
				if body.is_traveling():
					kill()
	if body.is_in_group("Boomerang"):
		if body.name == "Tip":
			if body.get_parent().shooter != self:
				kill()
		else:
			if body.shooter != self:
				kill()
	if body.is_in_group("Spikes"):
		kill()

func _on_double_click_timeout() -> void:
	first_click = false

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack":
		use_sword_once = false
