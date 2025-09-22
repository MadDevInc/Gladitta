extends Control

func kill():
	$AnimationPlayer.play("die")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		self.queue_free()
