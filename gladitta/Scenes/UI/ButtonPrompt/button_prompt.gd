extends Label

@onready var title : String = self.text

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if GLOBAL.joy_type == "keyboard":
			self.text = title
		elif GLOBAL.joy_type == "playstation":
			self.text = title + "P"
		else:
			self.text = title + "X"
