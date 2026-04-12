class_name Grunt
extends Enemy

func _init() -> void:
	health = 3
	speed = 2.0

func attack() -> void:
	if(randi_range(0,1) == 0):
		attack_anim.animation = "Unarmed_Melee_Attack_Punch_A"
	else:
		attack_anim.animation = "Unarmed_Melee_Attack_Punch_B"
	animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack_timer.start(randf_range(1.5,2))

func _on_vision_timer_timeout() -> void:
	aggro = false
