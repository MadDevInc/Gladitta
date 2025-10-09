extends Control

var current_selection = 0
var max_selection = 2

var next_scene

func _ready() -> void:
	if GLOBAL.finished_surface:
		current_selection = 1
	elif GLOBAL.finished_dungeon:
		current_selection = 2

func _physics_process(_delta: float) -> void:
	if $Worlds.get_child_count() > 0:
		$Camera2D.global_position.x = lerp($Camera2D.global_position.x, $Worlds.get_child(current_selection).global_position.x + $Worlds.get_child(current_selection).size.x/2, 0.1)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		if current_selection > 0:
			current_selection -= 1
		else:
			current_selection = max_selection
	if Input.is_action_just_pressed("move_right"):
		if current_selection < max_selection:
			current_selection += 1
		else:
			current_selection = 0
	if Input.is_action_just_pressed("jump"):
		select_level(current_selection)
		GLOBAL.current_playing_level = current_selection
		set_process(false)
	if Input.is_action_just_pressed("shoot"):
		transition_to("res://Scenes/UI/MainMenu/main_menu.tscn")

func select_level(idx):
	match idx:
		0:
			transition_to("res://Scenes/Worlds/Surface/LevelSelection/surface_level_selection.tscn")
		1:
			transition_to("res://Scenes/Worlds/Surface/LevelSelection/surface_level_selection.tscn")
		2:
			transition_to("res://Scenes/Worlds/Surface/LevelSelection/surface_level_selection.tscn")

func transition_to(target_scene):
	next_scene = target_scene
	$AnimationPlayer.play("fade_out")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene)
