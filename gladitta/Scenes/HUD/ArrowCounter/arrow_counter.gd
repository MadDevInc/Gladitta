extends Control

var arrow_icon_scene = load("res://Scenes/HUD/ArrowCounter/ArrowIcon/arrow_icon.tscn")

@onready var player = get_parent().get_parent().get_node("Player")

func _ready() -> void:
	for i in range(player.max_arrows):
		var arrow_icon_instance = arrow_icon_scene.instantiate()
		$HBoxContainer.add_child(arrow_icon_instance)

func _physics_process(_delta: float) -> void:
	if $HBoxContainer.get_child_count() < player.get_arrow_count():
		add_arrow()
	if $HBoxContainer.get_child_count() > player.get_arrow_count():
		remove_arrow()

func add_arrow():
	var arrow_icon_instance = arrow_icon_scene.instantiate()
	$HBoxContainer.add_child(arrow_icon_instance)

func remove_arrow():
	$HBoxContainer.get_child($HBoxContainer.get_child_count() - 1).kill()
