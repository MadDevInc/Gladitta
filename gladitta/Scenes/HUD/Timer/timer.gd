extends Control

var timer = 0.0

func _process(delta: float) -> void:
	timer += delta

	if timer < 10.0:
		$Label.text = "0" + str(timer).pad_decimals(2)
	else:
		$Label.text = str(timer).pad_decimals(2)
