class_name Key
extends Collectible

func _on_hitbox_body_entered(body: Node3D) -> void:
	body.keys += 1
	queue_free()
