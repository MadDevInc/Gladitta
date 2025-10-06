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
	value = new_value
	if value:
		$HBoxContainer/Value.text = "Options.Yes"
	else:
		$HBoxContainer/Value.text = "Options.No"

func add_value():
	value = !value
	if value:
		$HBoxContainer/Value.text = "Options.Yes"
	else:
		$HBoxContainer/Value.text = "Options.No"
	$change_value_anims.play("add_value")

func remove_value():
	value = !value
	if value:
		$HBoxContainer/Value.text = "Options.Yes"
	else:
		$HBoxContainer/Value.text = "Options.No"
	$change_value_anims.play("remove_value")

func get_value():
	return value

func select():
	selected.emit()
