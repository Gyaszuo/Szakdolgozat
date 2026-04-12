class_name Warrior
extends Enemy

func _init() -> void:
	health = 6
	speed = 2.0

func _ready() -> void:
	var rand = randi_range(0,1)
	if rand == 0:
		$"Body/model/Rig/Skeleton3D/handslot-r/Skeleton_Axe".visible = true
		$"Body/model/Rig/Skeleton3D/handslot-r/Skeleton_Blade".visible = false
	else:
		$"Body/model/Rig/Skeleton3D/handslot-r/Skeleton_Axe".visible = false
		$"Body/model/Rig/Skeleton3D/handslot-r/Skeleton_Blade".visible = true

func attack() -> void:
	var attack_type = randi_range(0,2)
	if(attack_type == 0):
		attack_anim.animation = "2H_Melee_Attack_Chop"
	elif(attack_type == 1):
		attack_anim.animation = "2H_Melee_Attack_Slice"
	else:
		attack_anim.animation = "2H_Melee_Attack_Spin"
	$Body/AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack_timer.start(randf_range(1.5,2))

func toggle_spin_hitbox(value: bool) -> void:
	$Body/model/Area3D2/CollisionShape3D.disabled = !value
	attacking = value

func _on_area_3d_2_body_entered(enter_body: Node3D) -> void:
	enter_body.hit()

func _on_vision_timer_timeout() -> void:
	aggro = false
