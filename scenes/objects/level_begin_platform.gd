class_name BeginPlatform
extends StaticBody3D

var used: bool = false:
	set(value):
		used = value
		if value == true:
			call_deferred("disable")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		used = true
		body.respawn_pos = $Marker3D.global_position
		get_parent().get_parent().get_parent().get_parent().save_game()

func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"used" : used
	}
	return save_dict
