class_name RespawnPlatform
extends StaticBody3D

var enabled: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and enabled:
		body.respawn_pos = $Marker3D.global_position
		get_parent().get_parent().get_parent().get_parent().save_game()
