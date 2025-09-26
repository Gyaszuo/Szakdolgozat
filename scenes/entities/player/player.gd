class_name Player
extends CharacterBody3D

@export var base_speed: float = 4.0
@export var run_speed: float = 6.0
@export var stop_speed: float = 1
@export var turn_speed: float = 3.0
@export var djump_impulse: float = 15.0
@export var jump_impulse: float = 105.0
@export var fall_speed: float = 0.99

@onready var camera: Camera = $Camera
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var jump_timer: Timer = $JumpTimer

var movement_input: Vector2 = Vector2.ZERO
var can_double_jump: bool = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("recenter_camera"):
		recenter_camera(delta)

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()

func move_logic(delta) -> void:
	movement_input = Input.get_vector("left","right","forward","backward").rotated(-camera.global_rotation.y)
	var velocity_2d = Vector2(velocity.x,velocity.z)
	var speed = base_speed
	if movement_input != Vector2.ZERO:
		velocity_2d += movement_input * speed * delta * 8.0
		velocity_2d = velocity_2d.limit_length(speed)
		var target_angle = -movement_input.angle() - PI/2
		mesh.rotation.y = rotate_toward(mesh.rotation.y,target_angle,turn_speed * delta)
		mesh.rotation.y = wrapf(mesh.rotation.y,-PI,PI)
	else:
		velocity_2d = velocity_2d.move_toward(Vector2.ZERO,speed * stop_speed * delta)
	velocity.x = velocity_2d.x
	velocity.z = velocity_2d.y

func jump_logic(delta) -> void:
	if is_on_floor():
		can_double_jump = true
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			jump_timer.start()
		if jump_timer.time_left:
			velocity.y += jump_impulse * delta
	if Input.is_action_just_pressed("jump"):	
		if !is_on_floor() and can_double_jump:
			can_double_jump = false
			velocity.y = djump_impulse
	else:
		velocity.y = clampf(velocity.y - fall_speed, -10.0,100)

func recenter_camera(delta: float) -> void:
	var tween = create_tween()
	tween.tween_property(camera,"rotation",mesh.rotation,delta * 10)
