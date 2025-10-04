extends Control

var current_selection = 0

var next_scene = ""

func _ready() -> void:
	update_hover()

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

func _on_play_selected() -> void:
	next_scene = "res://Scenes/Worlds/Surface/LevelSelection/surface_level_selection.tscn"
	$Transition.play("fade_out")

func _on_options_selected() -> void:
	$Menu/Options.open()

func _on_quit_selected() -> void:
	get_tree().quit()

func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene)
