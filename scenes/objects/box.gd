class_name Box
extends RigidBody3D

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"node_name" : name,
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
