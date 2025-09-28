extends Control

var current_selection = 0

var next_scene = ""

func _physics_process(delta: float) -> void:
	pass

func _on_play_selected() -> void:
	next_scene = load("res://Scenes/Worlds/Surface/LevelSelection/surface_level_selection.tscn")
	$Transition.play("fade_out")

func _on_quit_selected() -> void:
	get_tree().quit()


func _on_transition_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene)
