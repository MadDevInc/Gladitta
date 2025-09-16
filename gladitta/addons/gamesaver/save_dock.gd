@tool
class_name SaveDock
extends Control

var silent_mode : bool = false

func _process(delta: float) -> void:
	_display_save_data()

func _on_open_save_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://save.cfg"))

func _on_delete_save_pressed() -> void:
	if FileAccess.file_exists("user://save.cfg"):
		var error = DirAccess.remove_absolute("user://save.cfg")
		if error == 0:
			print("DELETOU O SAVE COM SUCESSO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg")
		else:
			print("NÃO FOI POSSíVEL DELETAR O ARQUIVO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg" + " COM ERRO DE NÚMERO " + str(error))
	else:
		print("ARQUIVO NÃO ENCONTRADO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg")

func _display_save_data() -> void:
	if FileAccess.file_exists("user://save.cfg"):
		var current_save_data = GameSaver.load_game()
		$VBoxContainer/SaveDataDisplay.text = str(current_save_data)
	else:
		$VBoxContainer/SaveDataDisplay.text = "nenhum save encontrado"
	$VBoxContainer/SavePathDisplay.text = OS.get_user_data_dir() + "/save.cfg"
