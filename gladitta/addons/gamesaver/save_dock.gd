@tool
class_name SaveDock
extends Control

const save_display_scene = preload("res://addons/gamesaver/save_display.tscn")

var display_tickrate = 0.2
var display_timer := 0.0

var silent_mode : bool = false

func _enter_tree() -> void:
	var save_count = 0
	var dir = DirAccess.open(OS.get_user_data_dir())
	if dir:
		var file_names = dir.get_files()
		for file in file_names:
			if "save" in file and ".cfg" in file:
				save_count += 1

	for i in range(save_count - 1):
		var new_save_display = save_display_scene.instantiate()
		new_save_display.name = "Slot" + str(i)
		$ScrollContainer/VBoxContainer/TabContainer.add_child(new_save_display)
		new_save_display.set_owner($ScrollContainer/VBoxContainer/TabContainer)

func _on_add_slot_pressed() -> void:
	var new_save_display = save_display_scene.instantiate()
	new_save_display.name = "Slot" + str($ScrollContainer/VBoxContainer/TabContainer.get_child_count() - 1)
	$ScrollContainer/VBoxContainer/TabContainer.add_child(new_save_display)
	new_save_display.set_owner($ScrollContainer/VBoxContainer/TabContainer)

func _on_remove_slot_pressed() -> void:
	if $ScrollContainer/VBoxContainer/TabContainer.get_child_count() > 1:
		if GameSaver.save_exists_in_slot($ScrollContainer/VBoxContainer/TabContainer.get_child_count() - 2):
			GameSaver.delete_save_in_slot($ScrollContainer/VBoxContainer/TabContainer.get_child_count() - 2)
		$ScrollContainer/VBoxContainer/TabContainer.get_child($ScrollContainer/VBoxContainer/TabContainer.get_child_count() - 1).queue_free()

func _process(delta: float) -> void:
	display_timer += delta
	if display_timer > 0.5:
		_display_save_data()
		display_timer = 0.0

func _display_save_data() -> void:
#Lidar com o save fora de slots
	if GameSaver.save_exists():
		var current_save_data = GameSaver.load_game()
		$ScrollContainer/VBoxContainer/TabContainer/Save.text = str(current_save_data)
	else:
		$ScrollContainer/VBoxContainer/TabContainer/Save.text = "nenhum save encontrado"
#Lidar com o save dentro de slots
	for i in range(1, $ScrollContainer/VBoxContainer/TabContainer.get_child_count()):
		if GameSaver.save_exists_in_slot(i - 1):
			$ScrollContainer/VBoxContainer/TabContainer.get_child(i).text = str(GameSaver.load_game_in_slot(i - 1))
		else:
			$ScrollContainer/VBoxContainer/TabContainer.get_child(i).text = "nenhum save encontrado"
#Atulizar a aba Local do Save
	$ScrollContainer/VBoxContainer/SavePathDisplay.text = OS.get_user_data_dir() + "/"

func _on_edit_pressed() -> void:
	var key_to_change = $ScrollContainer/VBoxContainer/Chave.text
	var new_value = $ScrollContainer/VBoxContainer/Valor.text
	var old_value

	var current_save_data
	if $ScrollContainer/VBoxContainer/TabContainer.current_tab == 0:
		if !GameSaver.save_exists():
			return
		current_save_data = GameSaver.load_game()
	else:
		if !GameSaver.save_exists_in_slot($ScrollContainer/VBoxContainer/TabContainer.current_tab - 1):
			return
		current_save_data = GameSaver.load_game_in_slot($ScrollContainer/VBoxContainer/TabContainer.current_tab - 1)

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

	var error
	if $ScrollContainer/VBoxContainer/TabContainer.current_tab == 0:
		error = GameSaver.save_game(current_save_data)
	else:
		
		error = GameSaver.save_game_in_slot(current_save_data, $ScrollContainer/VBoxContainer/TabContainer.current_tab - 1)

	if error == 0:
		print("ALTEROU COM SUCESSO O VALOR DA CHAVE \"" + key_to_change + "\" DE \"" + str(old_value) + "\" PARA \"" + str(new_value) + "\"")
	else:
		push_error("NÃO FOI POSSíVEL ALTERAR O VALOR DA CHAVE \"" + key_to_change + "\" DE \"" + str(old_value) + "\" PARA \"" + str(new_value) + "\" COM ERRO DE NÚMERO " + str(error))

	$ScrollContainer/VBoxContainer/Chave.text = ""
	$ScrollContainer/VBoxContainer/Valor.text = ""

func _on_open_save_folder_pressed() -> void:
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func _on_delete_save_pressed() -> void:
	if $ScrollContainer/VBoxContainer/TabContainer.current_tab == 0:
		GameSaver.delete_save()
	else:
		GameSaver.delete_save_in_slot($ScrollContainer/VBoxContainer/TabContainer.current_tab - 1)
