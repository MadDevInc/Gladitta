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

func select():
	$AnimationPlayer.play("select")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "select":
		get_tree().change_scene_to_file("res://Scenes/Levels/Levels/level_" + str(self.get_index()) + ".tscn")
