extends HBoxContainer

var dash_icon_scene = load("res://Scenes/HUD/DashCounter/DashIcon/dash_icon.tscn")

@onready var player = get_parent().get_parent().player

func _ready() -> void:
	for i in range(player.max_dashes):
		var dash_icon_instance = dash_icon_scene.instantiate()
		self.add_child(dash_icon_instance)

func _physics_process(_delta: float) -> void:
	if self.get_child_count() < player.get_dash_count():
		add_dash()
	if self.get_child_count() > player.get_dash_count():
		remove_dash()

func add_dash():
	var dash_icon_instance = dash_icon_scene.instantiate()
	self.add_child(dash_icon_instance)

func remove_dash():
	self.get_child(self.get_child_count() - 1).kill()
