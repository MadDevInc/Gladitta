extends Control

@onready var bronze_time = get_parent().get_parent().bronze_medal
@onready var silver_time = get_parent().get_parent().silver_medal
@onready var gold_time = get_parent().get_parent().gold_medal
@onready var dev_time = get_parent().get_parent().dev_medal

var intro_animation_finished = false

func _ready() -> void:
	if bronze_time < 10:
		$Frame/VBoxContainer/Bronze/HBoxContainer/Label.text = "0"
	if silver_time < 10:
		$Frame/VBoxContainer/Silver/HBoxContainer/Label.text = "0"
	if gold_time < 10:
		$Frame/VBoxContainer/Gold/HBoxContainer/Label.text = "0"
	if dev_time < 10:
		$Frame/VBoxContainer/Developer/HBoxContainer/Label.text = "0"

	$Frame/VBoxContainer/Bronze/HBoxContainer/Label.text += str(bronze_time).pad_decimals(3)
	$Frame/VBoxContainer/Silver/HBoxContainer/Label.text += str(silver_time).pad_decimals(3)
	$Frame/VBoxContainer/Gold/HBoxContainer/Label.text += str(gold_time).pad_decimals(3)
	$Frame/VBoxContainer/Developer/HBoxContainer/Label.text += str(dev_time).pad_decimals(3)

func open():
	self.show()
	var level_time = get_parent().get_node("HUD").get_time()
	if level_time < 10:
		$Frame/Time.text = "0" + str(level_time).pad_decimals(3)
	else:
		$Frame/Time.text = str(level_time).pad_decimals(3)

	var obtained_medal = 0
	if level_time < dev_time:
		obtained_medal = 3
	elif level_time < gold_time:
		obtained_medal = 2
	elif level_time < silver_time:
		obtained_medal = 1
	elif level_time < bronze_time:
		obtained_medal = 0
	else:
		obtained_medal = -1

	if obtained_medal >= 3:
		$Frame/VBoxContainer/Developer.show()

	match obtained_medal:
		0:
			$AnimationPlayer.play("bronze")
		1:
			$AnimationPlayer.play("silver")
		2:
			$AnimationPlayer.play("gold")
		3:
			$AnimationPlayer.play("developer")

	if GLOBAL.current_playing_level == GLOBAL.player_progress.size():
		var stats = {
			"time" : level_time,
			"medal": obtained_medal
		}
		GLOBAL.player_progress.append(stats)
	else:
		if level_time < GLOBAL.player_progress[GLOBAL.current_playing_level].time:
			GLOBAL.player_progress[GLOBAL.current_playing_level].time = level_time
		if obtained_medal > GLOBAL.player_progress[GLOBAL.current_playing_level].medal:
			GLOBAL.player_progress[GLOBAL.current_playing_level].medal = obtained_medal

	SAVEMANAGER.save_game()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		get_tree().paused = false
		get_tree().reload_current_scene()
		set_process(false)

	if Input.is_action_just_pressed("jump"):
		if !intro_animation_finished:
			intro_animation_finished = true
			$AnimationPlayer.speed_scale = 10.0
			return
		get_tree().paused = false
		GLOBAL.current_playing_level += 1
		if GLOBAL.current_playing_level == 10:
			GLOBAL.finished_surface = true
			get_tree().change_scene_to_file("res://Scenes/UI/WorldSelection/world_selection.tscn")
		elif GLOBAL.current_playing_level == 20:
			GLOBAL.finished_dungeon = true
			get_tree().change_scene_to_file("res://Scenes/UI/WorldSelection/world_selection.tscn")
		else:
			if GLOBAL.current_playing_level > 20:
				get_tree().change_scene_to_file("res://Scenes/Worlds/Depths/Levels/level_" + str(GLOBAL.current_playing_level) + ".tscn")
			elif GLOBAL.current_playing_level > 10:
				get_tree().change_scene_to_file("res://Scenes/Worlds/Dungeon/Levels/level_" + str(GLOBAL.current_playing_level) + ".tscn")
			else:
				get_tree().change_scene_to_file("res://Scenes/Worlds/Surface/Levels/level_" + str(GLOBAL.current_playing_level) + ".tscn")
		set_process(false)

	if Input.is_action_just_pressed("shoot"):
		if GLOBAL.current_playing_level == 10:
			GLOBAL.finished_surface = true
		elif GLOBAL.current_playing_level == 20:
			GLOBAL.finished_dungeon = true
		get_tree().paused = false
		if GLOBAL.current_playing_level > 20:
			get_tree().change_scene_to_file("res://Scenes/Worlds/Depths/LevelSelection/depths_level_selection.tscn")
		elif GLOBAL.current_playing_level > 10:
			get_tree().change_scene_to_file("res://Scenes/Worlds/Dungeon/LevelSelection/dungeon_level_selection.tscn")
		else:
			get_tree().change_scene_to_file("res://Scenes/Worlds/Surface/LevelSelection/surface_level_selection.tscn")
		set_process(false)

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	intro_animation_finished = true
