extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$SpinBox.value = $Player.GRAVITY
	$SpinBox2.value = $Player.SPEED
	$SpinBox3.value = $Player.JUMP_VELOCITY
	$SpinBox4.value = $Player.TERMINAL_FALLING_VELOCITY


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Player.GRAVITY = $SpinBox.value
	$Player.SPEED = $SpinBox2.value
	$Player.JUMP_VELOCITY = $SpinBox3.value
	$Player.TERMINAL_FALLING_VELOCITY = $SpinBox4.value
