@tool
class_name GameSaver
extends Node

##Uma classe para persistir informações em um arquivo criptografado.
##
##Exemplo de uso:
##[codeblock]
###Adicionando os dados em um dicionário chave-valor
##var data_to_save = {
##    "Nome": "Guerreiro"
##    "Vida": 137.5,
##    "Moedas": 250,
##    "Lista":[0, 255, "Maçãs", "Bananas"],
##}
###Salvando os dados
##GameSaver.save_game(data_to_save)
##
###Carregando os dados
##var save_data = GameSaver.load_game()
##
##[/codeblock]
##[b]Nota:[/b] Não é possível salvar instâncias de objetos. 
##Apesar disso, é possível armazenar os parâmetros a serem atribuídos à instâncias. Vide exemplo abaixo.[br]
##[br]
##Exemplo de implementação de um inventário simples:
##[codeblock]
###Exemplo de formatação dos dados a serem salvos
##var data_to_save = {
##    "itens":[ {"id": 0, "amount": 3}, {"id": 1, "amount": 10} ]
##}
##GameSaver.save_game(data_to_save)
##
###Exemplo de extração desses dados
##var save_data = GameSaver.load_game()
##
##var new_item = Item.new()
##new_item.id = save_data["itens"][0].id
##new_item.amount = save_data["itens"][0].amount
##
##var new_item_1 = Item.new()
##new_item_1.id = save_data.itens[1].id
##new_item_1.amount = save_data.itens[1].amount
##[/codeblock]
##

##Salva em um arquivo os dados contidos no [Dictionary] passado como parâmentro.[br]
##[br]
##[b]Nota:[/b] Descriptografa os arquivos utilizando a chave [param MadDev]. Vide [method ConfigFile.save_encrypted_pass].[br]
##[br]
##[b]Nota:[/b] Salva os arquivos no caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save.cfg]
static func save_game(data_to_save : Dictionary) -> int:
	var configFileInstance = ConfigFile.new()

	for key in data_to_save.keys():
		configFileInstance.set_value("save", key, data_to_save[key])

	var error = configFileInstance.save_encrypted_pass("user://save.cfg", "MadDev")
	if error != 0:
		_push_save_error("Não foi possível salvar no caminho" + OS.get_user_data_dir() + "/save.cfg com erro " + str(error))
		return error

	_print_save_feedback("Salvou com sucesso no caminho" + OS.get_user_data_dir() + "/save.cfg.")
	return 0 #SUCCESS

##Retorna um [Dictionary] contendo os dados salvos, caso existam. Do contrário, retorna um [Dictionary] vazio.[br]
##[br]
##[b]Nota:[/b] Descriptografa os arquivos utilizando a chave [param MadDev]. Vide [method ConfigFile.load_encrypted_pass].[br]
##[br]
##[b]Nota:[/b] Carrega os arquivos do caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save.cfg]
static func load_game() -> Dictionary:
	if !FileAccess.file_exists("user://save.cfg"):
		_push_save_warning("Não foram encontrados dados salvos no caminho" + OS.get_user_data_dir() + "/save.cfg. Retornando dicionário vazio.")
		return {}

	var configFileInstance = ConfigFile.new()

	var error = configFileInstance.load_encrypted_pass("user://save.cfg", "MadDev")
	if error != 0:
		_push_save_error("Não foi possível carregar do caminho" + OS.get_user_data_dir() + "/save.cfg com erro " + str(error))
		return error

	var loaded_data = {}
	for key in configFileInstance.get_section_keys("save"):
		var value = configFileInstance.get_value("save", key)
		loaded_data.get_or_add(key, value)

	return loaded_data

##Retorna [code]true[/code] caso exista um arquivo de save. Do contrário, retorna [code]false[/code].[br]
##[br]
##[b]Nota:[/b] Carrega os arquivos do caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save.cfg]
static func save_exists() -> bool:
	if FileAccess.file_exists("user://save.cfg"):
		return true
	else:
		return false

##Deleta o arquivo de save.[br]
##[br]
##[b]Nota:[/b] Deleta os arquivos no caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save.cfg]
static func delete_save() -> int:
	if !FileAccess.file_exists("user://save.cfg"):
		_push_save_warning("Não foi possível deletar no caminho" + OS.get_user_data_dir() + "/save.cfg: não foram encontrados dados salvos.")
		return ERR_FILE_NOT_FOUND
	else:
		var error = DirAccess.remove_absolute("user://save.cfg")
		if error != 0:
			_push_save_error("Não foi possível deletar no caminho " + OS.get_user_data_dir() + "/save.cfg com erro " + str(error))
			return error

	_print_save_feedback("Deletou com sucesso no caminho " + str(OS.get_user_data_dir() + "/save.cfg"))
	return 0

##Salva em um determinado slot os dados contidos no [Dictionary] passado como parâmentro.[br]
##[b]Nota: o slot é determinado adicionando o valor do slot ao final do nome do arquivo. Exemplo: [param save0.cfg], [param save1.cfg][br]
##[br]
##[b]Nota:[/b] Descriptografa os arquivos utilizando a chave [param MadDev]. Vide [method ConfigFile.save_encrypted_pass].[br]
##[br]
##[b]Nota:[/b] Salva os arquivos no caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save{SAVE_SLOT}.cfg]
static func save_game_in_slot(data_to_save : Dictionary, slot : int) -> int:
	var configFileInstance = ConfigFile.new()

	for key in data_to_save.keys():
		configFileInstance.set_value("save", key, data_to_save[key])

	var error = configFileInstance.save_encrypted_pass("user://save" + str(slot) + ".cfg", "MadDev")
	if error != 0:
		_push_save_error("Não foi possível salvar no caminho " + OS.get_user_data_dir() + "/save" + str(slot) + ".cfg com erro " + str(error))
		return error

	_print_save_feedback("Salvou com sucesso no caminho " + OS.get_user_data_dir() + "/save" + str(slot) + ".cfg")
	return 0 #SUCCESS

##Retorna um [Dictionary] contendo os dados salvos no slot passado como parâmetro, caso existam. Do contrário, retorna um [Dictionary] vazio.[br]
##[br]
##[b]Nota:[/b] Descriptografa os arquivos utilizando a chave [param MadDev]. Vide [method ConfigFile.load_encrypted_pass].[br]
##[br]
##[b]Nota:[/b] Carrega os arquivos do caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save{SAVE_SLOT}.cfg]
static func load_game_in_slot(slot : int) -> Dictionary:
	if !FileAccess.file_exists("user://save" + str(slot) + ".cfg"):
		print("nao achou no primeiro check, slot: " + str(slot))
		_push_save_warning("Não foram encontrados dados salvos no caminho " + OS.get_user_data_dir() + "/save" + str(slot) + ".cfg. Retornando dicionário vazio.")
		return {}

	var configFileInstance = ConfigFile.new()

	var error = configFileInstance.load_encrypted_pass("user://save" + str(slot) + ".cfg", "MadDev")
	if error != 0:
		_push_save_error("Não foi possível carregar do caminho " + OS.get_user_data_dir() + "/save" + str(slot) + ".cfg")
		return error

	var loaded_data = {}
	for key in configFileInstance.get_section_keys("save"):
		var value = configFileInstance.get_value("save", key)
		loaded_data.get_or_add(key, value)

	return loaded_data

##Retorna [code]true[/code] caso exista um arquivo de save no slot passado como parâmetro. Do contrário, retorna [code]false[/code].[br]
##[br]
##[b]Nota:[/b] Carrega os arquivos do caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save{SAVE_SLOT}.cfg]
static func save_exists_in_slot(slot : int) -> bool:
	if FileAccess.file_exists("user://save" + str(slot) + ".cfg"):
		return true
	else:
		return false

##Deleta o arquivo de save no slot passado como parâmetro.[br]
##[br]
##[b]Nota:[/b] Deleta os arquivos no caminho "user://".
##No Windows, esse caminho é [br][param C:/Users/{USUÁRIO}/AppData/Roaming/MadDev/{NOME_DO_PROJETO}/save{SAVE_SLOT}.cfg]
static func delete_save_in_slot(slot : int) -> int:
	if !FileAccess.file_exists("user://save" + str(slot) + ".cfg"):
		
		_push_save_warning("Não foi possível deletar no caminho " + OS.get_user_data_dir() + "/save" + str(slot) + ".cfg: não foram encontrados dados salvos.")
		return ERR_FILE_NOT_FOUND
	else:
		var error = DirAccess.remove_absolute("user://save" + str(slot) + ".cfg")
		if error != 0:
			_push_save_error("Não foi possível deletar no caminho " + OS.get_user_data_dir() + "/save" + str(slot) + ".cfg com erro " + str(error))
			return error

	_print_save_feedback("Deletou com sucesso no caminho " + str(OS.get_user_data_dir() + "/save" + str(slot) + ".cfg"))
	return 0

static func _print_save_feedback(message : String) -> void:
	#if !silent_mode:
	print(message)

static func _push_save_warning(message : String) -> void:
	#if !silent_mode:
	push_warning(message)

static func _push_save_error(message : String) -> void:
	push_error(message)
