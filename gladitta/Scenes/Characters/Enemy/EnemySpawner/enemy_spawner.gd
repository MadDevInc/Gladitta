@tool
extends Node2D

enum Directions {right = 1, left = -1}

@export var flying : bool
@export var moving : bool
@export var direction : Directions = Directions.right

@onready var initial_position = self.global_position
@onready var initial_direction = direction

var current_enemy = null

var skeleton_scene = load("res://Scenes/Characters/Enemy/Enemy/skeleton.tscn")
var bat_scene = load("res://Scenes/Characters/Enemy/Enemy/bat.tscn")

func _ready() -> void:
	if !Engine.is_editor_hint():
		$Sprite2D.hide()
		get_parent().get_parent().get_node("Player").death.connect(_on_player_death)
		generate_enemy()

func generate_enemy():
	var enemy_instance
	if flying:
		enemy_instance = bat_scene.instantiate()
	else:
		enemy_instance = skeleton_scene.instantiate()

	self.call_deferred("add_child", enemy_instance)
	current_enemy = enemy_instance
	current_enemy.flying = flying
	current_enemy.moving = moving
	current_enemy.direction = direction

func _on_player_death():
	if current_enemy != null:
		current_enemy.queue_free()
	generate_enemy()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if flying:
			$Sprite2D.texture = load("res://Scenes/Characters/Enemy/Enemy/Textures/bat.png")
		else:
			$Sprite2D.texture = load("res://Scenes/Characters/Enemy/Enemy/Textures/skeleton.png")
