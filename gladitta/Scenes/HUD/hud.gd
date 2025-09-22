extends Control

@export var player : CharacterBody2D

func reset_timer():
	$Timer.reset()

func stop_timer():
	$Timer.stop()

func get_time():
	return $Timer.get_time()
