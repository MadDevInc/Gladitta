extends Control

var current_selection = 0

func _ready() -> void:
	update_hover()

func _physics_process(_delta: float) -> void:
	pass
	#if Input.is_action_just_pressed("move_left"):
		#if current_selection > 0:
			#current_selection -= 1
		#else:
			#current_selection = $Stages.get_child_count() - 1
		#update_hover()
	#if Input.is_action_just_pressed("move_right"):
		#if current_selection < $Stages.get_child_count() - 1:
			#current_selection += 1
		#else:
			#current_selection = 0
		#update_hover()

func update_hover():
	for child in $Stages.get_children():
		if child.get_index() == current_selection:
			child.hover()
		else:
			child.unhover()
	var level_preview = load("res://Scenes/Levels/Levels/level_" + str(current_selection) + ".tscn").instantiate()
	$PreviewSlot.add_child(level_preview)
