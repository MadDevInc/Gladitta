extends VBoxContainer

var current_selection = 0

func open():
	self.show()

func close():
	self.hide()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_down"):
		if current_selection < self.get_child_count() - 1:
			current_selection += 1
		else:
			current_selection = 0
		update_hover()
	if Input.is_action_just_pressed("move_up"):
		if current_selection < 0:
			current_selection -= 1
		else:
			current_selection = self.get_child_count() - 1
		update_hover()
	if Input.is_action_just_pressed("jump"):
		self.get_child(current_selection).select()

func update_hover():
	for child in $VBoxContainer.get_children():
		if child.get_index() == current_selection:
			child.focus()
		else:
			child.unfocus()
