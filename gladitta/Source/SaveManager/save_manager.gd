extends Node

var unlock_bow = false
var unlock_boomer = false
var unlock_dash = false

func save_game():
	var data_to_save = {
		"player_progress" : GLOBAL.player_progress,
		"unlock_bow" : GLOBAL.unlock_bow,
		"unlock_boomer" : GLOBAL.unlock_boomer,
		"unlock_dash" : GLOBAL.unlock_dash
	}
	GameSaver.save_game(data_to_save)

func load_game():
	var loaded_data = GameSaver.load_game()
	GLOBAL.player_progress = loaded_data.player_progress
	GLOBAL.unlock_bow = loaded_data.unlock_bow
	GLOBAL.unlock_boomer = loaded_data.unlock_boomer
	GLOBAL.unlock_dash = loaded_data.unlock_dash
