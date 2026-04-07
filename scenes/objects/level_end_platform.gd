class_name LevelEndPlatform
extends StaticBody3D

signal next_level

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		next_level.emit()
