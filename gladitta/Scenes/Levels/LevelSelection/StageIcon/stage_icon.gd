extends Control

func hover():
	$AnimatedSprite2D.play("hover")
	$AnimationPlayer.play("hover")
	$LevelRender.show()
	$Overlay.show()

func unhover():
	if $AnimatedSprite2D.animation == "hover":
		$AnimatedSprite2D.play("unhover")
		$LevelRender.hide()
		$Overlay.hide()

func display(scene):
	$SubViewportContainer/SubViewport.add_child(scene)
	$SubViewportContainer/SubViewport.render_target_update_mode = SubViewport.UPDATE_ONCE
