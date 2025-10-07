extends Control

@export var levels_folder : String

var current_selection = 0
var max_selection = 0

var stage_icon_scene = preload("res://Scenes/Templates/LevelSelectionTemplate/StageIcon/stage_icon.tscn")

func _ready() -> void:
#ESSA REGIÃO DEVE SER REMOVIDA É APENAS PARA TESTE
	#SAVEMANAGER.load_game()
	#TranslationServer.set_locale("zh")
#FIM DA REGIAO DE TESTE
	var files = DirAccess.get_files_at(levels_folder)
	for i in range(files.size()):
		var new_stage_icon = stage_icon_scene.instantiate()
		$Stages.add_child(new_stage_icon)
		if i < GLOBAL.player_progress.size():
			new_stage_icon.set_medal(GLOBAL.player_progress[i].medal)

		var level_preview = load(levels_folder + "level_" + str(i) + ".tscn").instantiate()
		new_stage_icon.display(level_preview)

	if GLOBAL.player_progress.size() > 0:
		max_selection = GLOBAL.player_progress.size()

	update_hover()

func _process(_delta: float) -> void:
	if $Stages.get_child_count() > 0:
		$Camera2D.global_position.x = lerp($Camera2D.global_position.x, $Stages.get_child(current_selection).global_position.x + $Stages.get_child(current_selection).size.x/2, 0.5)
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

	if current_selection < GLOBAL.player_progress.size():
		$Camera2D/BestTimeDisplay.set_time(GLOBAL.player_progress[current_selection].time)
		$Camera2D/MedalDisplay.set_medal(GLOBAL.player_progress[current_selection].medal)
	else:
		$Camera2D/BestTimeDisplay.set_time(0.0)
		$Camera2D/MedalDisplay.set_medal(-1)
