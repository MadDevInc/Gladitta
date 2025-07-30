extends CharacterBody2D

enum Directions {right = 1, left = -1}

const SPEED = 15.0
const GRAVITY = 800.0

var flying : bool
var moving : bool
var direction : Directions = Directions.right

var activate_walk = false

func _physics_process(delta: float) -> void:
	if not is_on_floor() and !flying:
		velocity.y += GRAVITY * delta
	elif is_on_floor():
		activate_walk = true

	if moving:
		velocity.x = SPEED * direction

		if $RWallDetector.get_collider() != null and direction == 1:
			if $RWallDetector.get_collider().is_in_group("Solid"):
				switch_directions()
		if $LWallDetector.get_collider() != null and direction == -1:
			if $LWallDetector.get_collider().is_in_group("Solid"):
				switch_directions()
		
		if !flying and activate_walk:
			if $LSlopeDetector.get_collider() == null and direction == Directions.left:
				switch_directions()
			
			if $RSlopeDetector.get_collider() == null and direction == Directions.right:
				switch_directions()
		
		if direction == Directions.right:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
	else:
		if get_parent().get_parent().get_parent().get_node("Player").global_position.x > self.global_position.x:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

	move_and_slide()

func switch_directions():
	if direction == Directions.right:
		direction = Directions.left
	else:
		direction = Directions.right
