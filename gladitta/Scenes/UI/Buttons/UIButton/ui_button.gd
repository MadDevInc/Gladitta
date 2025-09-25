extends Control

signal selected

@export var title : String

func _ready() -> void:
	$HBoxContainer/Title.text = title

func focus():
	$HBoxContainer/LeftArrow.show()
	$HBoxContainer/RightArrow.show()

func unfocus():
	$HBoxContainer/LeftArrow.hide()
	$HBoxContainer/RightArrow.hide()

func hover_down():
	$AnimationPlayer.play("hover_down")

func hover_up():
	$AnimationPlayer.play("hover_up")

func set_value():
	pass

func add_value():
	pass

func remove_value():
	pass

func select():
	selected.emit()

func is_focused():
	if $HBoxContainer/LeftArrow.visible:
		return true
	else:
		return false
