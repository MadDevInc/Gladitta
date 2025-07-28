extends Node2D

var timer = 0.0

func _process(delta: float) -> void:
	timer += delta

	if timer < 10.0:
		$CanvasLayer/Timer.text = "0" + str(timer).pad_decimals(2)
	else:
		$CanvasLayer/Timer.text = str(timer).pad_decimals(2)
