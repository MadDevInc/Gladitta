extends Control

func set_time(new_time):
	print(new_time)
	$Label.text = "BestTimeDisplay.Title " + str(new_time)
