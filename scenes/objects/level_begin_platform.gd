class_name BeginPlatform
extends StaticBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.respawn_pos = $Marker3D.global_position
		get_parent().get_parent().get_parent().get_parent().save_game()
		call_deferred("disable")

func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true
