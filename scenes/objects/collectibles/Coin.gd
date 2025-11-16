class_name Coin
extends Collectible

func _on_hitbox_body_entered(body: Node3D) -> void:
	body.treasure += 1
	queue_free()

func spawn(pos: Vector3) -> void:
	var tween = create_tween()
	tween.tween_property(self,"global_position",pos,0.2)
