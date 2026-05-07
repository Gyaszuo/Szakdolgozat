class_name Boss
extends Enemy

@onready var boss_health: BossHealth = $BossHealth
@onready var move_state_machine_obj: AnimationNodeStateMachine = animation_tree.tree_root.get_node("MoveStateMachine")

var summons: int = 3
var magic: bool = false
var spinning: bool = false
var can_restart_melee_timer = false
var fireball_scene: PackedScene = preload("res://scenes/entities/enemies/Fireball.tscn") 
var rage_counter: int = 3
var phase: int = 1:
	set(value):
		phase = value
		if value == 1:
			phase_weapons(1)
			$Body/HookHitboxComponent/CollisionShape3D.disabled = false
			$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.visible = false
			$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.process_mode =Node.PROCESS_MODE_DISABLED
		elif value == 2:
			set_move_state("Block")
			$Body/HookHitboxComponent/CollisionShape3D.disabled = true
			$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.visible = true
			$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.process_mode =Node.PROCESS_MODE_INHERIT
		elif value == 3:
			hit()
			phase_weapons(3)
			speed = 3.0
			$Body/HookHitboxComponent/CollisionShape3D.disabled = false
			$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.visible = false
			$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.process_mode =Node.PROCESS_MODE_DISABLED
			move_state_machine_obj.get_node("Idle").animation = "2H_Melee_Idle"
			attack_timer.start(2)
		elif value == 4:
			set_move_state("Raise")
		else:
			hit()
			speed = 4.0
			phase_weapons(5)
			move_state_machine_obj.get_node("Idle").animation = "Idle_Combat"
var active_minions: int:
	set(value):
		active_minions = clampi(value,0,2)
const attacks = [
	"1H_Melee_Attack_Chop",
	"1H_Melee_Attack_Slice_Diagonal",
	"1H_Melee_Attack_Slice_Horizontal",
	"1H_Melee_Attack_Stab",
	"2H_Melee_Attack_Chop",
	"2H_Melee_Attack_Slice",
	"2H_Melee_Attack_Stab",
	"2H_Melee_Attack_Spin",
	"Dualwield_Melee_Attack_Slice",
	"Dualwield_Melee_Attack_Stab",
	"Dualwield_Melee_Attack_Chop",
	]
	
signal raise(count: int)

func guard_break_start():
	set_move_state("Hit_B")

func raise_minions():
	active_minions = 2
	raise.emit(summons)
	summons -= 1

func raise_start():
	print("Raise start: ",active_minions," ",summons)
	active_minions -= 1
	if active_minions == 0:
		if summons > 0:
			set_move_state("Raise")
		else:
			animation_tree.set("parameters/TimeScale/scale",1.5)
			set_move_state("Jump_Full_Short")

func guard_break():
	phase = 3

func phase_weapons(value: int):
	$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield.visible = false
	$"Body/model/Rig/Skeleton3D/handslot_l/1H_Sword_Offhand".visible = false
	$"Body/model/Rig/Skeleton3D/handslot_r/1H_Sword".visible = false
	$"Body/model/Rig/Skeleton3D/handslot_r/2H_Sword".visible = false
	$Body/model/Rig/Skeleton3D/head/Knight_Helmet.visible = false
	$Body/model/Rig/Skeleton3D/head/Skeleton_Warrior_Eyes.visible = false
	$Body/model/Rig/Skeleton3D/head/Skeleton_Warrior_Head.visible = false
	$Body/model/Rig/Skeleton3D/head/Skeleton_Warrior_Jaw.visible = false
	if value == 1:
		$"Body/model/Rig/Skeleton3D/handslot_r/1H_Sword".visible = true
		$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield.visible = true
		$Body/model/Rig/Skeleton3D/head/Knight_Helmet.visible = true
	elif value == 3:
		$"Body/model/Rig/Skeleton3D/handslot_r/2H_Sword".visible = true
		$Body/model/Rig/Skeleton3D/head/Knight_Helmet.visible = true
	elif value == 5:
		$"Body/model/Rig/Skeleton3D/handslot_r/1H_Sword".visible = true
		$"Body/model/Rig/Skeleton3D/handslot_l/1H_Sword_Offhand".visible = true
		$Body/model/Rig/Skeleton3D/head/Skeleton_Warrior_Eyes.visible = true
		$Body/model/Rig/Skeleton3D/head/Skeleton_Warrior_Head.visible = true
		$Body/model/Rig/Skeleton3D/head/Skeleton_Warrior_Jaw.visible = true
		move_state_machine_obj.get_node("Walking_D_Skeletons").animation = "Running_C"
		animation_tree.set("parameters/TimeScale/scale",1)
func movement_logic(delta: float) -> void:
	if dead or attacking or not active:
		return
	if phase == 2 or phase == 4:
		body.velocity = Vector3.ZERO
		var target_dir: Vector3 = (player.global_position - body.global_position).normalized()
		var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
		var target_angle: float = -target_v2.angle() + PI/2
		model.global_rotation.y = rotate_toward(model.global_rotation.y,target_angle,TURN_SPEED * delta)
		return
	if aggro:
		if not spinning:
			set_move_state(walk_anim)
		var target_dir: Vector3 = (player.global_position - body.global_position).normalized()
		var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
		var target_angle: float = -target_v2.angle() + PI/2
		model.global_rotation.y = rotate_toward(model.global_rotation.y,target_angle,TURN_SPEED * delta)
		if body.global_position.distance_to(player.global_position) > attack_range:
			body.velocity = Vector3(target_v2.x,0,target_v2.y) * speed
			if $Body/MeleeTimer.is_stopped() and can_restart_melee_timer:
				$Body/MeleeTimer.start(3.0)
				can_restart_melee_timer = false
			if dead or player == null or attacking:
				return
			if attack_timer.time_left == 0 and $Body/MeleeTimer.time_left == 0:
				ranged_attack()
		else:
			$Body/MeleeTimer.stop()
			can_restart_melee_timer = true
			body.velocity = Vector3.ZERO
			if not spinning:
				set_move_state("Idle")
			if dead or player == null or attacking or spinning or magic:
				return
			if attack_timer.time_left == 0:
				attack()
	else:
		body.velocity = Vector3.ZERO
		set_move_state("Idle")
	
	if !body.is_on_floor():
		set_move_state("Jump_Idle")
		body.velocity -= Vector3(0,10,0)
	body.move_and_slide()

func activate():
	set_move_state("Skeletons_Awaken_Standing")

func _init():
	health = 60
	speed = 2.0
	attack_range = 3.0

func hit() -> void:
	if phase == 2:
		set_move_state("Block_Hit")
		return
	elif phase == 4:
		return
	super.hit()

func attack():
	if phase == 1:
		var rand = randi_range(0,3)
		attack_anim.animation = attacks[rand]
		animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_timer.start(randf_range(2,2.5))
	elif phase == 3:
		var rand = randi_range(4,7)
		attack_anim.animation = attacks[rand]
		animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_timer.start(randf_range(3,3.5))
	elif phase == 5:
		var rand = randi_range(8,10)
		attack_anim.animation = attacks[rand]
		animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_timer.start(randf_range(1.5,2))

func ranged_attack():
	if phase == 3:
		var rand = randi_range(0,2)
		if rand < 2:
			var tween = create_tween()
			tween.tween_property(self,"speed",0.0,0.3)
			tween.tween_property(self,"speed",3.0,0.3)
			magic = true
			attack_anim.animation = "Spellcast_Shoot"
			animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
			attack_timer.start(randf_range(3.5,4))
		else:
			spin()
			attack_timer.start(4.5)
	elif phase == 5:
		var tween = create_tween()
		tween.tween_property(self,"speed",0.0,0.3)
		tween.tween_property(self,"speed",4.0,0.3)
		magic = true
		attack_anim.animation = "Spellcast_Shoot"
		animation_tree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_timer.start(randf_range(4,4.5))

func shoot():
	var target_dir: Vector3
	for i in range(phase):
		if phase == 3:
			target_dir = (player.global_position - $"Body/model/Rig/Skeleton3D/handslot_r/2H_Sword/Marker3D".global_position).normalized()
		else:
			target_dir = (player.global_position - $"Body/model/Rig/Skeleton3D/handslot_r/1H_Sword/Marker3D".global_position).normalized()
		var fireball: Fireball = fireball_scene.instantiate()
		get_parent().add_child(fireball)
		if phase == 3:
			fireball.global_position = $"Body/model/Rig/Skeleton3D/handslot_r/2H_Sword/Marker3D".global_position
		else:
			fireball.global_position = $"Body/model/Rig/Skeleton3D/handslot_r/1H_Sword/Marker3D".global_position
		fireball.direction = target_dir
		fireball.setup()
		await get_tree().create_timer(0.2).timeout
	magic = false

func spin():
	toggle_spin_hitbox(true)
	set_move_state("2H_Melee_Attack_Spinning")
	$Body/SpinTimer.start()
	spinning = true

func toggle_spin_hitbox(value: bool):
	$"Body/model/Rig/Skeleton3D/handslot_r/2H_Sword/SpinHitbox/CollisionShape3D".disabled = !value

func change_color(alpha: float):
	$"Body/model/Rig/Skeleton3D/handslot_l/1H_Sword_Offhand".material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield.material_overlay.set_shader_parameter('alpha',alpha)
	$"Body/model/Rig/Skeleton3D/handslot_r/1H_Sword".material_overlay.set_shader_parameter('alpha',alpha)
	$"Body/model/Rig/Skeleton3D/handslot_r/2H_Sword".material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/head/Knight_Helmet.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/chest/Knight_Cape.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Knight_ArmLeft.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Knight_ArmRight.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Knight_Body.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Knight_LegLeft.material_overlay.set_shader_parameter('alpha',alpha)
	$Body/model/Rig/Skeleton3D/Knight_LegRight.material_overlay.set_shader_parameter('alpha',alpha)

func start_boss():
	active = true
	animation_tree.set("parameters/TimeScale/scale",0.75)

func reset():
	$Body/model/Rig/Skeleton3D/handslot_l/Rectangle_Shield/HookSwitch.activated = false
	active = false
	phase = 1
	summons = 3
	active_minions = 0
	rage_counter = 3
	magic = false
	spinning = false
	attacking = false
	can_restart_melee_timer = false
	toggle_spin_hitbox(false)
	toggle_attack_hitbox(false)
	_init()
	model.global_rotation.y = deg_to_rad(180)
	animation_tree.set("parameters/TimeScale/scale",0.5)
	move_state_machine_obj.get_node("Walking_D_Skeletons").animation = "Walking_D_Skeletons"
	set_move_state("Skeleton_Inactive_Standing_Pose")

func update_healthbar(value):
	print(value)
	update_boss_healthbar(value)
	if value == 40:
		phase = 2
	elif value == 20:
		if spinning:
			$Body/SpinTimer.stop()
			$Body/SpinTimer.timeout.emit()
		phase = 4

func rage():
	rage_counter -= 1
	if rage_counter == 0:
		phase = 5
	else:
		set_move_state("Jump_Full_Short")

func update_boss_healthbar(value: int):
	if boss_health:
		boss_health.update_boss_healthbar(value)

func toggle_boss_healthbar(value: bool):
	boss_health.visible = value

func die() -> void:
	animation_tree.set("parameters/TimeScale/scale",0.25)
	dead = true
	call_deferred("disable_collision")
	extra_anim.animation = "Death_C_Skeletons"
	animation_tree.set("parameters/ExtraAnimOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	if aggro_cast:
		player.aggro_cast.remove_child(aggro_cast)
	await get_tree().create_timer(6).timeout
	death.emit()
	queue_free()

func _on_spin_timer_timeout() -> void:
	toggle_spin_hitbox(false)
	set_move_state("Walking_D_Skeletons")
	spinning = false

func _on_spin_hitbox_body_entered(param_body: Node3D) -> void:
	if "hit" in param_body:
		param_body.hit()
