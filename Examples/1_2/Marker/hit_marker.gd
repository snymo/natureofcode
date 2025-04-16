extends Node3D
# Hit marker for ball

func _on_timer_timeout():
	queue_free()
