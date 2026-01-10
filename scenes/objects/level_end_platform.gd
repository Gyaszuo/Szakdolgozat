class_name LevelEndPlatform
extends StaticBody3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		get_parent().get_parent().next_level()
