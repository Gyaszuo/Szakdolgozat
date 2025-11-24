class_name FallRescue
extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if "get_fall_pos" in body:
		body.get_fall_pos()
