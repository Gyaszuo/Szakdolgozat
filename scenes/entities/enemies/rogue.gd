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
