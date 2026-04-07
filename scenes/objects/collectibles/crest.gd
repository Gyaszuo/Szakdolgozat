class_name Crest
extends Collectible

func _on_hitbox_body_entered(body: Node3D) -> void:
	body.treasure += 100
	queue_free()

func get_value():
	return 100
