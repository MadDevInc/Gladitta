extends Node2D

@export var gold_medal = 0.0
@export var silver_medal = 0.0
@export var bronze_medal = 0.0

func _on_level_ending_level_finished() -> void:
	$CanvasLayer/Timer.stop()
	print("Passou de nível!")

func _process(_delta: float) -> void:
	for child in $Enemies.get_children():
		if child.current_enemy != null:
			return
	if $LevelEnding.is_locked():
		$LevelEnding.unlock()

func _on_player_death() -> void:
	$CanvasLayer/Timer.reset()
	$LevelEnding.reset()
	for child in $Arrows.get_children():
		child.queue_free()
