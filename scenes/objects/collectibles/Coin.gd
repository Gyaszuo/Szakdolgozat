class_name Coin
extends Collectible

func _on_hitbox_body_entered(body: Node3D) -> void:
	body.treasure += 1
	queue_free()

func spawn(pos: Vector3) -> void:
	var dir: Vector3 = global_position.direction_to(pos)
	$".".apply_impulse(dir)

func get_value():
	return 1
