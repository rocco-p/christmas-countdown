extends CPUParticles2D

func _ready() -> void:
	finished.connect(queue_free)
	z_index = 100
	emitting = true
