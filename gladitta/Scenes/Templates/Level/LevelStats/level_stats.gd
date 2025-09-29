extends Control

@onready var bronze_time = get_parent().get_parent().bronze_medal
@onready var silver_time = get_parent().get_parent().silver_medal
@onready var gold_time = get_parent().get_parent().gold_medal
@onready var dev_time = get_parent().get_parent().dev_medal

func _ready() -> void:
	$Background/VBoxContainer/Bronze/Label.text = str(bronze_time).pad_decimals(3)
	$Background/VBoxContainer/Silver/Label.text = str(silver_time).pad_decimals(3)
	$Background/VBoxContainer/Gold/Label.text = str(gold_time).pad_decimals(3)
	$Background/VBoxContainer/Developer/Label.text = str(dev_time).pad_decimals(3)

func open():
	self.show()
	var level_time = get_parent().get_node("HUD").get_time()
	if level_time < 10:
		$Background/Time.text = "0" + str(level_time).pad_decimals(3)
	else:
		$Background/Time.text = str(level_time).pad_decimals(3)

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

	if obtained_medal >= 0:
		for child in $Background/VBoxContainer.get_children():
			if child.get_index() <= obtained_medal:
				child.modulate.a = 1.0
	if obtained_medal >= 3:
		print()
		$Background/VBoxContainer/Developer.show()

	if GLOBAL.current_playing_level > GLOBAL.player_progress.size() - 1:
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
