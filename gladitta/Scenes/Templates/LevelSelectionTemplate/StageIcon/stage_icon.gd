extends Control

func hover():
	$AnimatedSprite2D.play("hover")
	$AnimationPlayer.play("hover")
	$Display.show()

func unhover():
	if $AnimatedSprite2D.animation == "hover":
		$AnimatedSprite2D.play("unhover")
		$Display.hide()

func display(scene):
	$SubViewportContainer/SubViewport.add_child(scene)
	$SubViewportContainer/SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
	await get_tree().create_timer(0.01).timeout #await para dar tempo de os inimigos spawnarem nas previews
	scene.process_mode = PROCESS_MODE_DISABLED

func set_medal(medal_idx):
	match medal_idx:
		0:
			$AnimatedSprite2D.modulate = Color("9a4a00")
		1:
			$AnimatedSprite2D.modulate = Color("adadad")
		2:
			$AnimatedSprite2D.modulate = Color("ffc700")
		3:
			$AnimatedSprite2D.modulate = Color("52bcff")

func select():
	$AnimationPlayer.play("select")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "select":
		get_tree().change_scene_to_file(get_parent().get_parent().levels_folder + "level_" + str(self.get_index()) + ".tscn")
