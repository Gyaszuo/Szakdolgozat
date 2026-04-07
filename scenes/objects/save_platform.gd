class_name RespawnPlatform
extends StaticBody3D

var enabled: bool = false:
	set(value):
		enabled = value
		if value:
			$MeshInstance3D/MeshInstance3D.mesh.material.albedo_color = Color(0,1,1,1)
signal save_game

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player and enabled:
		body.respawn_pos = $Marker3D.global_position
		save_game.emit()
