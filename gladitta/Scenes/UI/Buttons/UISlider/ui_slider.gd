extends Control

signal selected

@export var title : String

var value

func _ready() -> void:
	$Title.text = title

func focus():
	$HBoxContainer/LeftArrow.show()
	$HBoxContainer/RightArrow.show()

func unfocus():
	$HBoxContainer/LeftArrow.hide()
	$HBoxContainer/RightArrow.hide()

func hover_down():
	$hover_anims.play("hover_down")

func hover_up():
	$hover_anims.play("hover_up")

func set_value(new_value):
	value = int(new_value)
	$HBoxContainer/Value.text = str(value).pad_decimals(0)

func add_value():
	if value < 10.0:
		value += 1
	$HBoxContainer/Value.text = str(value).pad_decimals(0)
	$change_value_anims.play("add_value")

func remove_value():
	if value > 0.0:
		value -= 1
	$HBoxContainer/Value.text = str(value).pad_decimals(0)
	$change_value_anims.play("remove_value")

func get_value():
	return value

func select():
	selected.emit()
