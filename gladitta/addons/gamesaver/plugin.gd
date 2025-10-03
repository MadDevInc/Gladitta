@tool
extends EditorPlugin

var dock

func _ready() -> void:
#Essa linha é um workaround para compilar a documentação que será corrigido na versão 4.5 da Godot
	ResourceSaver.save(preload("res://addons/gamesaver/game_saver.gd"))

func _enter_tree() -> void:
#Essa linha é um workaround para compilar a documentação que será corrigido na versão 4.5 da Godot
	ResourceSaver.save(preload("res://addons/gamesaver/game_saver.gd"))

	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "MadDev/" + ProjectSettings.get_setting("application/config/name"))

	dock = preload("res://addons/gamesaver/save_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)

func _exit_tree() -> void:
	ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	ProjectSettings.set_setting("application/config/custom_user_dir_name", "MadDev/" + ProjectSettings.get_setting("application/config/name"))
	remove_control_from_docks(dock)
	dock.free()

#func _enable_plugin() -> void:
	#ProjectSettings.set_setting("application/config/use_custom_user_dir", true)
	#ProjectSettings.set_setting("application/config/custom_user_dir_name", "MadDev/" + ProjectSettings.get_setting("application/config/name"))

#func _disable_plugin():
	#ProjectSettings.set_setting("application/config/use_custom_user_dir", false)
	#ProjectSettings.set_setting("application/config/custom_user_dir_name", "")
#
	#remove_control_from_docks(dock)
	#dock.free()
