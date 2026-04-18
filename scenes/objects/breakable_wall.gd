class_name BreakableWall
extends Node3D

@export var hp: int = 3

func hit() -> void:
	hp -= 1
	var tween = create_tween()
	tween.tween_method(change_color,0.0,0.25,0.125)
	tween.tween_method(change_color,0.25,0.0,0.125)
	if hp <= 0:
		queue_free()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
		"hp" : hp,
		"rot_x" : global_rotation.x,
		"rot_y" : global_rotation.y,
		"rot_z" : global_rotation.z,
		"scale_x" : scale.x,
		"scale_y" : scale.y,
		"scale_z" : scale.z
	}
	return save_dict

func change_color(alpha: float):
	$broken_wall_leafless/wall_cracked.material_overlay.set_shader_parameter('alpha',alpha)
