extends HBoxContainer

var boomer_icon_scene = load("res://Scenes/HUD/BoomerCounter/BoomerIcon/boomer_icon.tscn")

@onready var player = get_parent().get_parent().player

func _ready() -> void:
	for i in range(player.max_boomer):
		var boomer_icon_instance = boomer_icon_scene.instantiate()
		self.add_child(boomer_icon_instance)

func _physics_process(_delta: float) -> void:
	if self.get_child_count() < player.get_boomer_count():
		add_boomer()
	if self.get_child_count() > player.get_boomer_count():
		remove_boomer()

func add_boomer():
	var boomer_icon_instance = boomer_icon_scene.instantiate()
	self.add_child(boomer_icon_instance)

func remove_boomer():
	self.get_child(self.get_child_count() - 1).kill()
