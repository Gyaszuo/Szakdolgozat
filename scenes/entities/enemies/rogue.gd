class_name Rogue
extends Enemy

func _init():
	health = 4
	speed = 4.0
	walk_anim = "Running_C"

func attack() -> void:
	var attack_type = randi_range(0,2)
	if(attack_type == 0):
		attack_anim.animation = "Dualwield_Melee_Attack_Chop"
	elif(attack_type == 1):
		attack_anim.animation = "Dualwield_Melee_Attack_Slice"
	else:
		attack_anim.animation = "Dualwield_Melee_Attack_Stab"
	animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack_timer.start(randf_range(1.5,2))

func change_color(alpha: float):
	$Body/model/Rig/Skeleton3D/head/Skeleton_Rogue_Hood.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/chest/Skeleton_Rogue_Cape.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_ArmLeft.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_ArmRight.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_Body.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_Eyes.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_Head.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_Jaw.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_LegLeft.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Skeleton_Rogue_LegRight.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/right_handslot/Skeleton_Blade/Skeleton_Blade.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/left_handslot/Skeleton_Blade/Skeleton_Blade.material_overlay.set_shader_parameter('alpha',alpha)
