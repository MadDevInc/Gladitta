extends Area2D

signal level_finished

@export_enum("iron", "wood") var door_type = "iron"

@export var locked = true

@onready var reset_lock = locked

var is_player_inside = false

func is_locked():
	return locked

func unlock():
	locked = false
	$AnimatedSprite2D.play(door_type)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = false

func _process(_delta: float) -> void:
	if is_player_inside and !locked:
		level_finished.emit()

func reset():
	locked = reset_lock
	$AnimatedSprite2D.frame = 0
