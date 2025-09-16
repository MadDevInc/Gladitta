@tool
extends EditorPlugin

var dock

func _ready() -> void:
	print("plugin ready")
#Essa linha é um workaround para compilar a documentação que será corrigido na versão 4.5 da Godot
	ResourceSaver.save(preload("res://addons/gamesaver/game_saver.gd"))

func _enter_tree() -> void:
	print("enter tree")
#Essa linha é um workaround para compilar a documentação que será corrigido na versão 4.5 da Godot
	ResourceSaver.save(preload("res://addons/gamesaver/game_saver.gd"))

	dock = preload("res://addons/gamesaver/save_dock.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)

func _disable_plugin():
	remove_control_from_docks(dock)
	dock.free()
