class_name Player
extends CharacterBody3D

@onready var camera: Camera = $Camera
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var jump_timer: Timer = $Timers/JumpTimer
@onready var attack_timer: Timer = $Timers/AttackTimer
@onready var ground_pound_timer: Timer = $Timers/GroundPoundTimer
@onready var attack_cooldown_timer: Timer = $Timers/AttackCooldownTimer
@onready var attack_area: Area3D = $AttackArea
@onready var ground_pound_area: Area3D = $GroundPoundArea
@onready var roll_cooldown_timer: Timer = $Timers/RollCooldownTimer
@onready var hook_launch_point: Marker3D = $MeshInstance3D/HookLaunchPoint
@onready var invulnerability_timer: Timer = $Timers/InvulnerabilityTimer
@onready var main_ui: MainUI = $MainUi

var movement_input: Vector2 = Vector2.ZERO
var can_double_jump: bool = true
var attack_count: int = 3
var run_speed: float = 6.0
var base_speed: float = 4.0
var stop_speed: float = 2.0
var turn_speed: float = 3.0
var djump_impulse: float = 15.0
var jump_impulse: float = 0.8
var fall_speed: float = 1.0
var is_ground_pounding: bool = false
var is_running: bool = false
var is_dead: bool = false

var is_hooking: bool = false
var hook_target: Vector3
var prev_position: Vector3

var health: int = 6:
	set(value):
		health = value
		main_ui.update_health(value)
		if value == 0:
			die()

const MAX_WALK: float = 4.0
const MAX_RUN: float = 6.0
const HOOK_SPEED: float = 6.0
const HOOK_MIN_DIST: float = 2.0

signal shoot_hook(direction: Vector3)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("recenter_camera"):
		recenter_camera(delta)

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic()
	ability_logic(delta)
	finish_ground_pound()
	move_and_slide()
	end_hooking()

func move_logic(delta: float) -> void:
	prev_position = position
	if is_hooking:
		var hook_dir = global_position.direction_to(hook_target)
		velocity = hook_dir * HOOK_SPEED
		var hook_dir_2d = Vector2(hook_dir.x,hook_dir.z)
		var target_angle = -hook_dir_2d.angle() - PI/2
		mesh.rotation.y = rotate_toward(mesh.rotation.y,target_angle,turn_speed * delta)
		attack_area.rotation.y = rotate_toward(attack_area.rotation.y,target_angle,turn_speed * delta)
		return
	movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera.global_rotation.y)
	var velocity_2d = Vector2(velocity.x,velocity.z)
	var speed = base_speed
	if movement_input != Vector2.ZERO:
		if Input.is_action_pressed("sprint"):
			is_running = true
		else:
			is_running = false
		speed = run_speed if is_running else base_speed
		if is_dead:
			speed = 0.0
		velocity_2d += movement_input * speed * delta * 8.0
		velocity_2d = velocity_2d.limit_length(speed)
		var target_angle = -movement_input.angle() - PI/2
		mesh.rotation.y = rotate_toward(mesh.rotation.y,target_angle,turn_speed * delta)
		attack_area.rotation.y = rotate_toward(attack_area.rotation.y,target_angle,turn_speed * delta)
		mesh.rotation.y = wrapf(mesh.rotation.y,-PI,PI)
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO,speed * stop_speed * delta)
	velocity.x = velocity_2d.x
	velocity.z = velocity_2d.y

func jump_logic() -> void:
	if is_hooking:
		if Input.is_action_just_pressed("jump"):
			velocity.y = djump_impulse
			is_hooking = false
		return
	if is_ground_pounding:
		return
	if is_on_floor():
		can_double_jump = true
	if Input.is_action_pressed("jump"):
		if is_dead:
			return
		if is_on_floor():
			jump_timer.start()
		if jump_timer.time_left:
			velocity.y += jump_impulse
	if Input.is_action_just_pressed("jump"):
		if !is_on_floor() and can_double_jump and not is_dead:
			can_double_jump = false
			velocity.y = djump_impulse
	else:
		if !is_ground_pounding and !is_on_floor() and !jump_timer.time_left:
			velocity.y = clampf(velocity.y - fall_speed, -15.0,100)

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
		roll()
	if Input.is_action_just_pressed("hook"):
		hook()
	if Input.is_action_just_pressed("hit"):
		hit()

func attack() -> void:
	if attack_cooldown_timer.time_left or is_hooking:
		return
	attack_timer.stop()
	print("AttackAnim", attack_count % 2)
	attack_count -= 1
	attack_area.get_child(0).disabled = false
	await get_tree().create_timer(0.1).timeout
	attack_area.get_child(0).disabled = true
	attack_timer.start()
	if attack_count == 0:
		attack_cooldown_timer.start()

func ground_pound(delta) -> void:
	if !is_ground_pounding:
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
	attack_area.get_child(0).disabled = true
	attack_count = 3

func _on_attack_area_body_entered(body: Node3D) -> void:
	if "hit" in body.get_parent():
		body.get_parent().hit()

func _on_ground_pound_area_body_entered(body: Node3D) -> void:
	if "hit" in body.get_parent():
		body.get_parent().hit()

func _on_attack_cooldown_timer_timeout() -> void:
	attack_count = 3

func _on_attack_timer_timeout() -> void:
	attack_count = 3

func roll() -> void:
	if roll_cooldown_timer.time_left:
		return
	base_speed = 10.0
	run_speed = 10.0
	set_collision_mask_value(3,false)
	set_collision_mask_value(4,false)
	await get_tree().create_timer(0.2).timeout
	set_collision_mask_value(3,true)
	set_collision_mask_value(4,true)
	toggle_speed(true)
	roll_cooldown_timer.start()

func hook() -> void:
	var direction: Vector3 = hook_launch_point.global_position.direction_to(camera.collision_point)
	shoot_hook.emit(direction)

func travel_hook(target: Vector3) -> void:
	hook_target = target
	is_hooking = true

func end_hooking() -> void:
	if hook_target.distance_to(global_position) <= HOOK_MIN_DIST or prev_position == position or Input.is_action_just_pressed("hook"):
		is_hooking = false

func hit() -> void:
	if not invulnerability_timer.time_left and not is_dead:
		health -= 1
		invulnerability_timer.start()

func die() -> void:
	var tween = create_tween()
	tween.tween_property(main_ui.color_rect,"color",Color(0,0,0,1),1.0)
	is_dead = true
