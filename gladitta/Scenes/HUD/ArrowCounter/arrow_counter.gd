extends Control

@export var player : CharacterBody2D

var arrow_icon_scene = load("res://Scenes/HUD/ArrowCounter/ArrowIcon/arrow_icon.tscn")

func _physics_process(_delta: float) -> void:
	if player.get_arrow_count() > $VBoxContainer.get_child_count():
		add_arrow()
	if player.get_arrow_count() < $VBoxContainer.get_child_count():
		remove_arrow()

func add_arrow():
	var arrow_icon_instance = arrow_icon_scene.instantiate()
	$VBoxContainer.add_child(arrow_icon_instance)

func remove_arrow():
	$VBoxContainer.get_child($VBoxContainer.get_child_count() - 1).kill()
