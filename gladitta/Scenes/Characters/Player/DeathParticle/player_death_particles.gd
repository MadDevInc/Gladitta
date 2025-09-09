extends GPUParticles2D

func _ready() -> void:
	emitting = true
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$GPUParticles2D4.emitting = true
	$GPUParticles2D5.emitting = true

func _on_finished() -> void:
	queue_free()
