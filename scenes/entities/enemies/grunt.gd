class_name Grunt
extends Enemy

func _init() -> void:
	health = 3
	speed = 2.0

func attack() -> void:
	if not active:
		return
	if(randi_range(0,1) == 0):
		attack_anim.animation = "Unarmed_Melee_Attack_Punch_A"
	else:
		attack_anim.animation = "Unarmed_Melee_Attack_Punch_B"
	animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack_timer.start(randf_range(1.5,2))

func change_color(alpha: float):
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_ArmLeft.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_ArmRight.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_Body.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_Cloak.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_Eyes.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_Head.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_Jaw.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_LegLeft.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Minion_LegRight.material_overlay.set_shader_parameter('alpha',alpha)
