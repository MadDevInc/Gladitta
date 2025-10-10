extends Control

@export var player : CharacterBody2D

func _ready() -> void:
	if GLOBAL.current_playing_level > 9:
		GLOBAL.unlock_bow = true
	if GLOBAL.current_playing_level:
		pass

	if GLOBAL.unlock_bow:
		$HBoxContainer/ArrowCounter.show()
	if GLOBAL.unlock_boomer:
		$HBoxContainer/BoomerCounter.show()
	if GLOBAL.unlock_dash:
		$HBoxContainer/DashCount.show()

func reset_timer():
	$Timer.reset()

func stop_timer():
	$Timer.stop()

func get_time():
	return $Timer.get_time()
