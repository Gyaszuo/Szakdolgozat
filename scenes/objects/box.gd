class_name Box
extends CharacterBody3D

@export var fall_speed = 5.0
const STOP_SPEED = 2.0
const PUSH_FORCE = 3.0

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y = clampf(velocity.y - fall_speed, -15.0,100)
	var velocity_2d = Vector2(velocity.x,velocity.z).move_toward(Vector2.ZERO,PUSH_FORCE * STOP_SPEED * delta)
	velocity.x = velocity_2d.x
	velocity.z = velocity_2d.y
	move_and_slide()
	push()

func push() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is Box:
			c.get_collider().velocity = (-c.get_normal() * PUSH_FORCE)

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"name" : name,
		"fall_speed" : fall_speed,
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
