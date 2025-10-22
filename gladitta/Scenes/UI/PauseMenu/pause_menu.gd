extends Control

var current_selection = 0

func _physics_process(_delta: float) -> void:
	if $Menu.visible:
		if Input.is_action_just_pressed("move_down"):
			if current_selection < $Menu.get_child_count() - 1:
				current_selection += 1
			else:
				current_selection = 0
			update_hover()
		if Input.is_action_just_pressed("move_up"):
			if current_selection > 0:
				current_selection -= 1
			else:
				current_selection = $Menu.get_child_count() - 1
			update_hover()
		if Input.is_action_just_pressed("jump"):
			$Menu.get_child(current_selection).select()

func update_hover():
	for child in $Menu.get_children():
		if child.get_index() == current_selection:
			child.focus()
		else:
			child.unfocus()

func _on_options_closed() -> void:
	$Menu.show()

func _on_resume_selected() -> void:
	self.hide()
	get_tree().paused = false

func _on_quit_level_selected() -> void:
	pass

func _on_settings_selected() -> void:
	$Options.open()

func _on_quit_selected() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/MainMenu/main_menu.tscn")
