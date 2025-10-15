extends Node

var current_playing_level = 0

var player_progress = []

var finished_surface = false
var finished_dungeon = false

var unlock_bow = false
var unlock_boomer = false
var unlock_dash = false

var joy_type = "keyboard"

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("key_F11"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	if event is InputEventKey:
		joy_type = "keyboard"
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if "Xbox" in Input.get_joy_name(0):
			joy_type = "xbox"
		elif "PS" in Input.get_joy_name(0):
			joy_type = "playstation"
		else:
			joy_type = "xbox"

#func _process(delta: float) -> void:
	#print(player_progress)
