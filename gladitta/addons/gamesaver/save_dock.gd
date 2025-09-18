@tool
class_name SaveDock
extends Control

var silent_mode : bool = false

func _process(delta: float) -> void:
	_display_save_data()

func _display_save_data() -> void:
	if FileAccess.file_exists("user://save.cfg"):
		var current_save_data = GameSaver.load_game()
		$ScrollContainer/VBoxContainer/SaveDataDisplay.text = str(current_save_data)
	else:
		$ScrollContainer/VBoxContainer/SaveDataDisplay.text = "nenhum save encontrado"
	$ScrollContainer/VBoxContainer/SavePathDisplay.text = OS.get_user_data_dir() + "/save.cfg"

func _on_edit_pressed() -> void:
	var key_to_change = $ScrollContainer/VBoxContainer/Chave.text
	var new_value = $ScrollContainer/VBoxContainer/Valor.text
	var old_value

	if !FileAccess.file_exists("user://save.cfg"):
		push_error("NÃO FOI POSSíVEL ENCONTRAR O ARQUIVO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg")
		return

	var current_save_data = GameSaver.load_game()

	if key_to_change == "":
		push_error("ESCOLHA A CHAVE A SER ALTERADA")
		return

	if not key_to_change in current_save_data.keys():
		push_error("NÃO FOI POSSÍVEL ENCONTRAR A CHAVE \"" + key_to_change + "\"")
		return

	if new_value == "":
		push_error("ESCOLHA O NOVO VALOR PARA A CHAVE \"" + key_to_change + "\"")
		return

	if str_to_var(new_value) == null:
		push_error("NÃO FOI POSSÍVEL ALTERAR A CHAVE \"" + key_to_change + "\": VALOR INVÁLIDO.")
		return

	for key in current_save_data.keys():
		if key == key_to_change:
			old_value = current_save_data[key]
			current_save_data[key] = str_to_var(new_value)
			break

	var error = GameSaver.save_game(current_save_data)
	if error == 0:
		print("ALTEROU COM SUCESSO O VALOR DA CHAVE \"" + key_to_change + "\" DE \"" + str(old_value) + "\" PARA \"" + str(new_value) + "\"")
	else:
		push_error("NÃO FOI POSSíVEL ALTERAR O VALOR DA CHAVE \"" + key_to_change + "\" DE \"" + str(old_value) + "\" PARA \"" + str(new_value) + "\" COM ERRO DE NÚMERO " + str(error))

	$ScrollContainer/VBoxContainer/Chave.text = ""
	$ScrollContainer/VBoxContainer/Valor.text = ""

func _on_open_save_folder_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func _on_delete_save_pressed() -> void:
	if FileAccess.file_exists("user://save.cfg"):
		var error = DirAccess.remove_absolute("user://save.cfg")
		if error == 0:
			print("DELETOU O SAVE COM SUCESSO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg")
		else:
			push_error("NÃO FOI POSSíVEL DELETAR O ARQUIVO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg" + " COM ERRO DE NÚMERO " + str(error))
	else:
		push_error("NÃO FOI POSSíVEL ENCONTRAR O ARQUIVO NO CAMINHO " + OS.get_user_data_dir() + "/save.cfg")
