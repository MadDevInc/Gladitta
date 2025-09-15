extends Control

var current_selection = 0

var stage_icon_scene = preload("res://Scenes/Levels/LevelSelection/StageIcon/stage_icon.tscn")

func _ready() -> void:
	var files = DirAccess.get_files_at("res://Scenes/Levels/Levels/")
	for i in range(files.size()):
		var new_stage_icon = stage_icon_scene.instantiate()
		$Stages.add_child(new_stage_icon)

		var level_preview = load("res://Scenes/Levels/Levels/level_" + str(i) + ".tscn").instantiate()
		new_stage_icon.display(level_preview)
	update_hover()

func _physics_process(_delta: float) -> void:
	$Camera2D.global_position.x = lerp($Camera2D.global_position.x, $Stages.get_child(current_selection).global_position.x + $Stages.get_child(current_selection).size.x/2, 0.1)
	if Input.is_action_just_pressed("move_left"):
		if current_selection > 0:
			current_selection -= 1
		else:
			current_selection = $Stages.get_child_count() - 1
		update_hover()
	if Input.is_action_just_pressed("move_right"):
		if current_selection < $Stages.get_child_count() - 1:
			current_selection += 1
		else:
			current_selection = 0
		update_hover()

func update_hover():
	for child in $Stages.get_children():
		if child.get_index() == current_selection:
			child.hover()
		else:
			child.unhover()
