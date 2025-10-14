class_name Lock
extends Activator

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.keys > 0:
		body.keys -= 1
		activate()
		queue_free()
