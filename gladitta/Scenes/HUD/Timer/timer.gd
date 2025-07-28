extends Control

var timer = 0.0
var stopped_time

func _process(delta: float) -> void:
	timer += delta

	if timer < 10.0:
		$Label.text = "0" + str(timer).pad_decimals(2)
	else:
		$Label.text = str(timer).pad_decimals(2)

func stop():
	set_process(false)
	stopped_time = timer
	if timer < 10.0:
		$Label.text = "0" + str(stopped_time).pad_decimals(2)
	else:
		$Label.text = str(stopped_time).pad_decimals(2)
