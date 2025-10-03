extends Control

func set_time(new_time):
	$HBoxContainer/Title.text = "BestTimeDisplay.Title"
	$HBoxContainer/value.text = str(new_time).pad_decimals(3)
