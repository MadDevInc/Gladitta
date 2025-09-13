extends Control

func hover():
	$AnimatedSprite2D.play("hover")
	$AnimationPlayer.play("hover")

func unhover():
	if $AnimatedSprite2D.animation == "hover":
		$AnimatedSprite2D.play("unhover")
