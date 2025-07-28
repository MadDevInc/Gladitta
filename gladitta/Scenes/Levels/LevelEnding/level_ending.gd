extends Area2D

signal level_finished

@export var locked = true

var is_player_inside = false

func unlock():
	locked = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_player_inside = false

func _process(_delta: float) -> void:
	if is_player_inside and !locked:
		level_finished.emit()
