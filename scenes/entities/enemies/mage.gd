class_name Mage
extends Enemy

var fireball_scene: PackedScene = preload("res://scenes/entities/enemies/Fireball.tscn") 

func _init() -> void:
	health = 4
	speed = 2.0
	attack_range = 15

func attack() -> void:
	animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func shoot() -> void:
	var tween = create_tween()
	tween.tween_property(self,"speed",0.0,0.3)
	tween.tween_property(self,"speed",2.0,0.3)
	var target_dir: Vector3 = (player.global_position - body.global_position).normalized()
	var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
	var fireball: Fireball = fireball_scene.instantiate()
	get_parent().add_child(fireball)
	fireball.global_position = $Body/model/Rig/Skeleton3D/BoneAttachment3D/Skeleton_Staff/Marker3D.global_position
	fireball.direction = target_v2
