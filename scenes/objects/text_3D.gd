class_name Text3D
extends Label3D

var camera: Camera3D

func _process(delta: float) -> void:
	if camera == null:
		camera = get_tree().get_nodes_in_group("Player")[0].camera.camera_3d
	var target_dir: Vector3 = (camera.global_position - global_position).normalized()
	var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
	var target_angle: float = -target_v2.angle() + PI/2
	global_rotation.y = rotate_toward(global_rotation.y,target_angle,20 * delta)
