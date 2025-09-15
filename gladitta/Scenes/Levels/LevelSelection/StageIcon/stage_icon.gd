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
