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

###Se [code]true[/code] o GameSaver envia logs de salvamento para o output.[br]
###[br]
###[b]Nota:[/b] Esta propriedade é para fins de debug, não interferindo no funcionamento do GameSaver.
###Não se aplica aos outputs da aba Save.
#static var silent_mode : bool = false

###Se [code]true[/code] o GameSaver criptografa o arquivo de save.[br]
###[br]
###[b]Nota:[/b] É recomendado criptografar os arquivos de save na versão final do jogo.
#static var encrypt_data : bool = false

##Salva em um arquivo os dados contidos no [Dictionary] passado como parâmentro.[br]
##[br]
##[b]Nota:[/b] Os arquivos são criptografados utilizando a chave "MadDev". Vide [method ConfigFile.save_encrypted_pass].[br]
##[br]
##[b]Nota:[/b] Os arquivos são salvos no caminho "user://".
##No Windows, esse caminho é [br][code]C:/Users/[USER]/AppData/Roaming/Godot/app_userdata/[PROJECT_NAME]/save.cfg[/code]
static func save_game(data_to_save : Dictionary) -> int:
	var configFileInstance = ConfigFile.new()

	for key in data_to_save.keys():
		configFileInstance.set_value("save", key, data_to_save[key])

	var error
	error = configFileInstance.save("user://save.cfg")
	if error != 0:
		_print_save_feedback("Não foi possível salvar com erro " + str(error))
		return error

	_print_save_feedback("Salvou com sucesso no caminho " + str(OS.get_user_data_dir()))
	return 0 #SUCCESS

##Retorna um [Dictionary] contendo os dados salvos, caso existam. Do contrário, retorna um [Dictionary] vazio.[br]
##[br]
##[b]Nota:[/b] Os arquivos são descriptografados utilizando a chave "MadDev". Vide [method ConfigFile.load_encrypted_pass].[br]
##[br]
##[b]Nota:[/b] Os arquivos são carregados do caminho "user://".
##No Windows, esse caminho é [br][code]C:/Users/[USER]/AppData/Roaming/Godot/app_userdata/[PROJECT_NAME]/save.cfg[/code]
static func load_game() -> Dictionary:
	if !FileAccess.file_exists("user://save.cfg"):
		_push_save_warning("Não foram encontrados dados salvos. Retornando dicionário vazio.")
		return {}

	var configFileInstance = ConfigFile.new()
	configFileInstance.load("user://save.cfg")

	var loaded_data = {}
	for key in configFileInstance.get_section_keys("save"):
		var value = configFileInstance.get_value("save", key)
		loaded_data.get_or_add(key, value)

	return loaded_data

##Retorna [code]true[/code] caso exista um arquivo de save. Do contrário, retorna [code]false[/code].[br]
##[br]
##[b]Nota:[/b] Os arquivos são carregados do caminho "user://".
##No Windows, esse caminho é [br][code]C:/Users/[USER]/AppData/Roaming/Godot/app_userdata/[PROJECT_NAME]/save.cfg[/code]
static func save_exists() -> bool:
	if FileAccess.file_exists("user://save.cfg"):
		return true
	else:
		return false

##Deleta o arquivo de save.
##[br]
##[b]Nota:[/b] Os arquivos são deletados no caminho "user://".
##No Windows, esse caminho é [br][code]C:/Users/[USER]/AppData/Roaming/Godot/app_userdata/[PROJECT_NAME]/save.cfg[/code]
static func delete_save() -> int:
	if !FileAccess.file_exists("user://save.cfg"):
		_push_save_warning("delete_save() falhou: Não foram encontrados dados salvos.")
		return ERR_FILE_NOT_FOUND
	else:
		var error = DirAccess.remove_absolute("user://save.cfg")
		if error != 0:
			_print_save_feedback("Não foi possível deletar com erro " + str(error))
			return error

	_print_save_feedback("Deletou com sucesso no caminho " + str(OS.get_user_data_dir()))
	return 0

static func _print_save_feedback(message : String) -> void:
	#if !silent_mode:
	print(message)

static func _push_save_warning(message : String) -> void:
	#if !silent_mode:
	push_warning(message)
