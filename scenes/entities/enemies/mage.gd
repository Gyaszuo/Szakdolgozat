class_name Mage
extends Enemy

var fireball_scene: PackedScene = preload("res://scenes/entities/enemies/Fireball.tscn") 

func _init() -> void:
	health = 4
	speed = 2.0
	attack_range = 15

func attack() -> void:
	animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack_timer.start(randf_range(1.5,2))

func shoot() -> void:
	var tween = create_tween()
	tween.tween_property(self,"speed",0.0,0.3)
	tween.tween_property(self,"speed",2.0,0.3)
	var target_dir: Vector3 = (player.global_position - $Body/model/Rig/Skeleton3D/BoneAttachment3D/Skeleton_Staff/Marker3D.global_position).normalized()
	var fireball: Fireball = fireball_scene.instantiate()
	get_parent().add_child(fireball)
	fireball.global_position = $Body/model/Rig/Skeleton3D/BoneAttachment3D/Skeleton_Staff/Marker3D.global_position
	fireball.direction = target_dir

func _on_vision_timer_timeout() -> void:
	aggro = false
