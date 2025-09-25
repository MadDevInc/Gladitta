extends Control

signal selected

@export var title : String

@export var list : PackedStringArray

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
	var parsed_string = new_value.split("_")
	if parsed_string[0] in list:
		value = parsed_string[0]
	$HBoxContainer/Value.text = value

func add_value():
	if list.find(value) + 1 > list.size() - 1:
		value = list[0]
	else:
		value = list[list.find(value) + 1]
	$HBoxContainer/Value.text = value
	$change_value_anims.play("add_value")

func remove_value():
	if list.find(value) - 1 < 0:
		value = list[list.size() - 1]
	else:
		value = list[list.find(value) - 1]
	$HBoxContainer/Value.text = value
	$change_value_anims.play("remove_value")

func get_value():
	return value

func select():
	selected.emit()

func set_label_text(new_text):
	$HBoxContainer/Value.text = new_text
