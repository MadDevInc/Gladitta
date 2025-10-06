extends VBoxContainer

signal closed

var current_selection = 0

func open():
	set_toggles()
	update_hover()
	self.show()

func close():
	current_selection = 0
	self.hide()
	closed.emit()

func set_toggles():
	$Language.set_value(TranslationServer.get_locale())
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$Fullscreen.set_value(true)
	else:
		$Fullscreen.set_value(false)
	$Music.set_value(db_to_linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")) ) * 10.0)
	$Sounds.set_value(db_to_linear( AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sounds")) ) * 10.0)

func _physics_process(_delta: float) -> void:
	if self.visible:
		if Input.is_action_just_pressed("move_down"):
			if current_selection < self.get_child_count() - 1:
				current_selection += 1
			else:
				current_selection = 0
			update_hover()
		if Input.is_action_just_pressed("move_up"):
			if current_selection > 0:
				current_selection -= 1
			else:
				current_selection = self.get_child_count() - 1
			update_hover()
		if Input.is_action_just_pressed("jump"):
			self.get_child(current_selection).select()
		if Input.is_action_just_pressed("move_right"):
			self.get_child(current_selection).add_value()
			update_toggles()
		if Input.is_action_just_pressed("move_left"):
			self.get_child(current_selection).remove_value()
			update_toggles()
		if Input.is_action_just_pressed("shoot"):
			close()

func update_hover():
	for child in self.get_children():
		if child.get_index() == current_selection:
			child.focus()
		else:
			child.unfocus()

func update_toggles():
	TranslationServer.set_locale($Language.get_value())
	if $Fullscreen.get_value():
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db($Music.get_value()/10.0))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sounds"), linear_to_db($Sounds.get_value()/10.0))

func _on_back_selected() -> void:
	close()
