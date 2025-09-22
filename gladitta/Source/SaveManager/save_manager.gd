extends Node

func save_game():
	var data_to_save = {
		"player_progress" : GLOBAL.player_progress
	}
	GameSaver.save_game(data_to_save)

func load_game():
	var loaded_data = GameSaver.load_game()
	GLOBAL.player_progress = loaded_data.player_progress
