extends HBoxContainer

var arrow_icon_scene = load("res://Scenes/HUD/ArrowCounter/ArrowIcon/arrow_icon.tscn")

@onready var player = get_parent().get_parent().player

func _ready() -> void:
	for i in range(player.max_arrows):
		var arrow_icon_instance = arrow_icon_scene.instantiate()
		self.add_child(arrow_icon_instance)

func _physics_process(_delta: float) -> void:
	if self.get_child_count() < player.get_arrow_count():
		add_arrow()
	if self.get_child_count() > player.get_arrow_count():
		remove_arrow()

func add_arrow():
	var arrow_icon_instance = arrow_icon_scene.instantiate()
	self.add_child(arrow_icon_instance)

func remove_arrow():
	self.get_child(self.get_child_count() - 1).kill()
