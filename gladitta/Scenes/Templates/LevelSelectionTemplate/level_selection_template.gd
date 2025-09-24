extends Control

@export var levels_folder : String

var current_selection = 0
var max_selection = 0

var stage_icon_scene = preload("res://Scenes/Templates/LevelSelectionTemplate/StageIcon/stage_icon.tscn")

func _ready() -> void:
	var files = DirAccess.get_files_at(levels_folder)
	for i in range(files.size()):
		var new_stage_icon = stage_icon_scene.instantiate()
		$Stages.add_child(new_stage_icon)

		var level_preview = load(levels_folder + "level_" + str(i) + ".tscn").instantiate()
		new_stage_icon.display(level_preview)
	update_hover()

func _process(_delta: float) -> void:
	if $Stages.get_child_count() > 0:
		$Camera2D.global_position.x = lerp($Camera2D.global_position.x, $Stages.get_child(current_selection).global_position.x + $Stages.get_child(current_selection).size.x/2, 0.1)
	if Input.is_action_just_pressed("move_left"):
		if current_selection > 0:
			current_selection -= 1
		else:
			current_selection = max_selection
		update_hover()
	if Input.is_action_just_pressed("move_right"):
		if current_selection < max_selection:
			current_selection += 1
		else:
			current_selection = 0
		update_hover()
	if Input.is_action_just_pressed("jump"):
		$Stages.get_child(current_selection).select()
		GLOBAL.current_playing_level = current_selection
		set_process(false)

func update_hover():
	for child in $Stages.get_children():
		if child.get_index() == current_selection:
			child.hover()
		else:
			child.unhover()
