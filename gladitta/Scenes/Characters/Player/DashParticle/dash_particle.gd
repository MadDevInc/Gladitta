extends AnimatedSprite2D

func set_animation_and_frame(new_animation, new_frame):
	animation = new_animation
	frame = new_frame

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		self.queue_free()
