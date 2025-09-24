extends Control

func set_medal(medals):
	for child in $HBoxContainer.get_children():
		if child.get_index() <= medals:
			child.show()
		else:
			child.hide()
