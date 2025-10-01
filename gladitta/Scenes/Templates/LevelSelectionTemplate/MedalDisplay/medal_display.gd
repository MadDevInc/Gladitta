extends Control

func set_medal(medals):
	for child in $HBoxContainer.get_children():
		if child.get_index() <= medals:
			child.modulate.a = 1.0
		else:
			child.modulate.a = 0.125
