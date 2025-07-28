extends Node2D

@export var gold_medal = 0.0
@export var silver_medal = 0.0
@export var bronze_medal = 0.0

func _on_level_ending_level_finished() -> void:
	$CanvasLayer/Timer.stop()
	print("Passou de nível!")

func _process(_delta: float) -> void:
	if $Enemies.get_child_count() <= 0:
		$LevelEnding.unlock()
