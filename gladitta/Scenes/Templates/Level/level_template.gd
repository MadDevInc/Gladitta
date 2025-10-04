extends Node2D

@export var dev_medal = 0.0
@export var gold_medal = 0.0
@export var silver_medal = 0.0
@export var bronze_medal = 0.0

func _on_level_ending_level_finished() -> void:
	$CanvasLayer/HUD.stop_timer()
	$CanvasLayer/LevelStats.open()
	get_tree().paused = true

func _process(_delta: float) -> void:
	for child in $Enemies.get_children():
		if child.current_enemy != null:
			return
	if $LevelEnding.is_locked():
		$LevelEnding.unlock()

func _on_player_death() -> void:
	$CanvasLayer/HUD.reset_timer()
	$LevelEnding.reset()

func shake_camera():
	$Camera2D/AnimationPlayer.play("shake")
	freeze_frame()

func freeze_frame():
	get_tree().paused = true
	await get_tree().create_timer(0.05).timeout
	get_tree().paused = false
