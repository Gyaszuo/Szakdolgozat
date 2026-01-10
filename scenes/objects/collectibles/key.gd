class_name Key
extends Collectible

func _on_hitbox_body_entered(body: Node3D) -> void:
	body.keys += 1
	queue_free()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"node_name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
		"rot_x" : global_rotation.x,
		"rot_y" : global_rotation.y,
		"rot_z" : global_rotation.z,
		"scale_x" : scale.x,
		"scale_y" : scale.y,
		"scale_z" : scale.z
	}
	return save_dict
