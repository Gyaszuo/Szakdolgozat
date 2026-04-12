class_name HeartPickup
extends Collectible

func _on_hitbox_body_entered(body: Node3D) -> void:
	body.health += 2
	queue_free()
