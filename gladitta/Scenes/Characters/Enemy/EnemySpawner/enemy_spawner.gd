extends Node2D

enum Directions {right = 1, left = -1}

@export var flying : bool
@export var moving : bool
@export var direction : Directions = Directions.right

@onready var initial_position = self.global_position
@onready var initial_direction = direction

var current_enemy = null

var enemy_scene = load("res://Scenes/Characters/Enemy/WalkingEnemy/walking_enemy.tscn")

func _ready() -> void:
	get_parent().get_parent().get_node("Player").death.connect(_on_player_death)
	current_enemy = $Enemy
	current_enemy.flying = flying
	current_enemy.moving = moving
	current_enemy.direction = direction

func generate_enemy():
	var enemy_instance = enemy_scene.instantiate()
	self.call_deferred("add_child", enemy_instance)
	current_enemy = enemy_instance
	current_enemy.flying = flying
	current_enemy.moving = moving
	current_enemy.direction = direction

func _on_player_death():
	if current_enemy != null:
		current_enemy.queue_free()
	generate_enemy()
