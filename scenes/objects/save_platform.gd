class_name RespawnPlatform
extends StaticBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.respawn_pos = $Marker3D.global_position
