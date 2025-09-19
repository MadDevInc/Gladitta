extends Control

func open():
	self.show()
	$Background/VBoxContainer/Time.text = get_parent().get_node("Timer").get_time().pad_decimals(3)
	$Background/VBoxContainer/Bronze/Label.text = str(get_parent().get_parent().bronze_medal).pad_decimals(3)
	$Background/VBoxContainer/Silver/Label.text = str(get_parent().get_parent().silver_medal).pad_decimals(3)
	$Background/VBoxContainer/Gold/Label.text = str(get_parent().get_parent().gold_medal).pad_decimals(3)
