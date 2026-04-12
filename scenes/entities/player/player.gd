class_name Player
extends CharacterBody3D

@onready var camera: Camera = $Camera
@onready var mesh = $ModelPivot
@onready var jump_timer: Timer = $Timers/JumpTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var ground_pound_timer: Timer = $Timers/GroundPoundTimer
@onready var attack_cooldown_timer: Timer = $Timers/AttackCooldownTimer
@onready var attack0_area: Area3D = $Attack0Area
@onready var attack1_area: Area3D = $Attack1Area
@onready var ground_pound_area: Area3D = $GroundPoundArea
@onready var dodge_cooldown_timer: Timer = $Timers/DodgeCooldownTimer
@onready var hook_launch_point: Marker3D = $"ModelPivot/Rogue_Hooded/Rig/Skeleton3D/handslot_r/1H_Crossbow/HookLaunchPoint"
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var ground_pound_cooldown_timer: Timer = $Timers/GroundPoundCooldownTimer
@onready var main_ui: MainUI = $MainUi
@onready var aggro_cast: Node3D = $AggroCasts
@onready var squash_and_stretch_component: SqashAndStretchComponent = $SquashAndStretchComponent
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_state_machine: AnimationNodeStateMachinePlayback = $AnimationTree.get("parameters/AttackStateMachine/playback")
@onready var extra_anim: AnimationNodeAnimation = $AnimationTree.get_tree_root().get_node('ExtraAnimation')
var movement_input: Vector2 = Vector2.ZERO
var can_double_jump: bool = true
var attack_count: int = 3:
	set(value):
		attack_count = value
var run_speed: float = 6.0
var base_speed: float = 4.0
var stop_speed: float = 2.0
var turn_speed: float = 6.0
var djump_impulse: float = 15.0
var jump_impulse: float = 1.0
var fall_speed: float = 1.0
var is_ground_pounding: bool = false
var is_running: bool = false
var is_dead: bool = false
var is_attacking: bool = false
var is_hooking: bool = false
var hook_target: Vector3
var prev_position: Vector3
var respawn_pos: Vector3 = Vector3(0,1,0)
var fall_rescue_pos: Vector3 = Vector3(0,1,0)
var dashing: bool = false
var barrier_blocked = false
var dash_vector: Vector3

var health: int = 6:
	set(value):
		health = clamp(value,0,6)
		main_ui.update_health(value)
		if value == 0:
			die()

var keys: int = 0:
	set(value):
		keys = value
		main_ui.update_keys(value)
		
var treasure: int = 0:
	set(value):
		treasure = value
		main_ui.update_treasure(value)

const MAX_WALK: float = 4.0
const MAX_RUN: float = 6.0
const HOOK_SPEED: float = 6.0
const HOOK_MIN_DIST: float = 2.0
const PUSH_FORCE = 3.0

signal shoot_hook(direction: Vector3)
signal quit

func _ready() -> void:
	print("player")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("recenter_camera"):
		recenter_camera(delta)

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic()
	ability_logic(delta)
	finish_ground_pound()
	move_and_slide()
	push()
	end_hooking()

func move_logic(delta: float) -> void:
	prev_position = position
	if dashing:
		velocity = velocity.move_toward(Vector3.ZERO,base_speed * stop_speed * delta *2)
		return
	if is_hooking:
		var hook_dir = global_position.direction_to(hook_target)
		velocity = hook_dir * HOOK_SPEED
		var hook_dir_2d = Vector2(hook_dir.x,hook_dir.z)
		var target_angle = -hook_dir_2d.angle() - PI/2
		mesh.global_rotation.y = rotate_toward(mesh.global_rotation.y,target_angle,turn_speed * delta)
		attack0_area.global_rotation.y = rotate_toward(attack0_area.global_rotation.y,target_angle,turn_speed * delta)
		attack1_area.global_rotation.y = rotate_toward(attack1_area.global_rotation.y,target_angle,turn_speed * delta)
		return
	movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera.global_rotation.y)
	var velocity_2d = Vector2(velocity.x,velocity.z)
	var speed = base_speed
	if movement_input != Vector2.ZERO:
		if Input.is_action_pressed("sprint"):
			is_running = true
			if is_on_floor():
				set_move_state("Running")
		else:
			is_running = false
			if is_on_floor():
				set_move_state("Walking")
		speed = run_speed if is_running else base_speed
		if is_dead:
			speed = 0.0
		velocity_2d += movement_input * speed * delta * 8.0
		velocity_2d = velocity_2d.limit_length(speed)
		var target_angle = -movement_input.angle() - PI/2
		mesh.global_rotation.y = rotate_toward(mesh.global_rotation.y,target_angle,turn_speed * delta)
		attack0_area.global_rotation.y = rotate_toward(attack0_area.global_rotation.y,target_angle,turn_speed * delta)
		attack1_area.global_rotation.y = rotate_toward(attack1_area.global_rotation.y,target_angle,turn_speed * delta)
		mesh.global_rotation.y = wrapf(mesh.global_rotation.y,-PI,PI)
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO,speed * stop_speed * delta)
		if is_on_floor():
			set_move_state("Idle")
	velocity.x = velocity_2d.x
	velocity.z = velocity_2d.y

func jump_logic() -> void:
	if is_hooking:
		set_move_state("Jump_Idle")
		if Input.is_action_just_pressed("jump"):
			set_move_state("Jump_Idle")
			squash_and_stretch_component.do_squash_and_stretch(1.2,0.15)
			if barrier_blocked:
				fall_speed = 1.0
				barrier_blocked = false
			velocity.y = djump_impulse
			is_hooking = false
		return
	if is_ground_pounding:
		return
	if is_on_floor():
		can_double_jump = true
		if barrier_blocked:
			fall_speed = 1.0
			barrier_blocked = false
	if Input.is_action_pressed("jump"):
		if is_dead:
			return
		if is_on_floor():
			jump_timer.start()
			set_move_state("Jump_Idle")
			squash_and_stretch_component.do_squash_and_stretch(1.2,0.15)
		if jump_timer.time_left:
			velocity.y += jump_impulse
	if Input.is_action_just_pressed("jump"):
		double_jump()
	else:
		if !is_ground_pounding and !is_on_floor() and !jump_timer.time_left:
			velocity.y = clampf(velocity.y - fall_speed, -15.0,100)
			if move_state_machine.get_current_node() != "Jump_Idle":
				set_move_state("Jump_Idle")

func double_jump() -> void:
	if !is_on_floor() and can_double_jump and not is_dead:
		if barrier_blocked:
			fall_speed = 1.0
			barrier_blocked = false
		jump_timer.stop()
		set_move_state("Jump_Idle")
		squash_and_stretch_component.do_squash_and_stretch(1.2,0.15)
		can_double_jump = false
		velocity.y = djump_impulse

func recenter_camera(delta: float) -> void:
	var tween = create_tween()
	tween.tween_property(camera,"rotation",mesh.rotation,delta * 10)

func ability_logic(delta) -> void:
	if is_dead:
		return
	if Input.is_action_just_pressed("attack"):
		if is_on_floor():
			attack()
		else:
			ground_pound(delta)
	if Input.is_action_just_pressed("roll") and is_on_floor():
		dodge()
	if Input.is_action_just_pressed("hook"):
		hook()
	if Input.is_action_just_pressed("hit"):
		fall()

func attack() -> void:
	if attack_cooldown_timer.time_left or is_hooking or is_attacking:
		return
	attack_timer.stop()
	var anim_name: String = "Attack" + str(attack_count % 2)
	attack_state_machine.travel(anim_name)
	$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	attack_count -= 1
	if attack_count == 0:
		attack_cooldown_timer.start()

func ground_pound(delta) -> void:
	if !is_ground_pounding and not ground_pound_cooldown_timer.time_left and not is_hooking:
		set_move_state("Sit")
		toggle_speed(false)
		is_ground_pounding = true
		var tween = create_tween()
		tween.tween_property(self,"velocity",Vector3(0,-30,0),delta * 10)

func finish_ground_pound() -> void:
	if is_on_floor() and is_ground_pounding:
		toggle_speed(true)
		is_ground_pounding = false
		ground_pound_area.get_child(0).disabled = false
		ground_pound_timer.start()
		ground_pound_cooldown_timer.start()

func toggle_speed(toggle: bool) -> void:
	if not toggle:
		base_speed = 0
		run_speed = 0
	else:
		base_speed = MAX_WALK
		run_speed = MAX_RUN

func _on_ground_pound_timer_timeout() -> void:
	ground_pound_area.get_child(0).disabled = true

func _on_attack_hitbox_fade_timeout() -> void:
	attack_cooldown_timer.start()
	attack0_area.get_child(0).disabled = true
	attack1_area.get_child(0).disabled = true
	attack_count = 3

func _on_attack_area_body_entered(body: Node3D) -> void:
	if "hit" in body.get_parent():
		body.get_parent().hit()

func _on_ground_pound_area_body_entered(body: Node3D) -> void:
	if "hit" in body.get_parent():
		body.get_parent().hit()

func _on_attack_area_area_entered(area: Area3D) -> void:
	if "hit" in area.get_parent():
		area.get_parent().hit()

func _on_ground_pound_area_area_entered(area: Area3D) -> void:
	if "hit" in area.get_parent():
		area.get_parent().hit()

func _on_attack_cooldown_timer_timeout() -> void:
	attack_count = 3

func _on_attack_timer_timeout() -> void:
	attack_count = 3

func dodge() -> void:
	if dodge_cooldown_timer.time_left or movement_input == Vector2.ZERO:
		return
	dodge_cooldown_timer.start()
	extra_anim.animation = "Dodge_Forward"
	$AnimationTree.set("parameters/ExtraOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	velocity = Vector3(movement_input.x,0,movement_input.y) * 10
	dashing = true
	await get_tree().create_timer(0.4).timeout
	dashing = false

func hook() -> void:
	if get_parent().get_parent().find_child("Hooks").get_children().size() == 0:
		call_deferred("toggle_main_hand",true)
		var direction: Vector3 = hook_launch_point.global_position.direction_to(camera.collision_point)
		shoot_hook.emit(direction)

func travel_hook(target: Vector3) -> void:
	hook_target = target
	is_hooking = true

func end_hooking() -> void:
	if hook_target.distance_to(global_position) <= HOOK_MIN_DIST or (prev_position == position and is_hooking) or Input.is_action_just_pressed("hook"):
		is_hooking = false

func hit() -> void:
	if not invulnerability_timer.time_left and not is_dead and not dashing:
		extra_anim.animation = "Hit_A"
		$AnimationTree.set("parameters/ExtraOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		$AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
		enable_attack0_hitbox(false)
		enable_attack1_hitbox(false)
		can_attack(false)
		health -= 1
		invulnerability_timer.start()
		is_hooking = false

func die() -> void:
	is_dead = true
	set_collision_layer_value(2,false)
	$AnimationTree.set("parameters/DeathOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	var tween = create_tween()
	tween.tween_property(main_ui.color_rect,"color",Color(0,0,0,1),2.0)
	await tween.finished
	global_position = respawn_pos
	health = 6
	$AnimationTree.set("parameters/DeathOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
	tween = create_tween()
	tween.tween_property(main_ui.color_rect,"color",Color(0,0,0,0),2.0)
	is_dead = false
	set_collision_layer_value(2,true)

func push() -> void:
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is Box:
			c.get_collider().velocity = (-c.get_normal() * PUSH_FORCE)

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func can_attack(value: bool) -> void:
	is_attacking = value

func enable_attack0_hitbox(value: bool) -> void:
	if value:
		attack0_area.get_child(0).disabled = false
	else:
		attack0_area.get_child(0).disabled = true
		attack_timer.start()

func enable_attack1_hitbox(value: bool) -> void:
	if value:
		attack1_area.get_child(0).disabled = false
	else:
		attack1_area.get_child(0).disabled = true
		attack_timer.start()

func toggle_main_hand(value: bool) -> void:
	$"ModelPivot/Rogue_Hooded/Rig/Skeleton3D/handslot_r/1H_Crossbow".visible = value
	$ModelPivot/Rogue_Hooded/Rig/Skeleton3D/handslot_r/Knife.visible = !value

func get_fall_pos():
	fall_rescue_pos = $FallRaycast.get_collision_point() + Vector3(0,1,0)
	
func fall():
	global_position = fall_rescue_pos

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
		"health" : health,
		"keys" : keys,
		"treasure" : treasure,
		"respawn_pos_x" : respawn_pos.x,
		"respawn_pos_y" : respawn_pos.y,
		"respawn_pos_z" : respawn_pos.z,
		"fall_rescue_pos_x" : fall_rescue_pos.x,
		"fall_rescue_pos_y" : fall_rescue_pos.y,
		"fall_rescue_pos_z" : fall_rescue_pos.z,
		"rot_x" : global_rotation.x,
		"rot_y" : global_rotation.y,
		"rot_z" : global_rotation.z,
		"scale_x" : scale.x,
		"scale_y" : scale.y,
		"scale_z" : scale.z
	}
	return save_dict

func quit_game() -> void:
	print("quit in Player")
	quit.emit()
