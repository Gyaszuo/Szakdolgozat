class_name Mage
extends Node3D

@export var health: int = 4:
	set(value):
		print(health)
		if value >= 0:
			health = value
			if health == 0:
				die()
@export var speed: float = 2.0

@onready var body: CharacterBody3D = $Mage
@onready var model: Node3D = $Mage/model
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $Mage/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_anim: AnimationNodeAnimation = $Mage/AnimationTree.get_tree_root().get_node('AttackAnimation')
@onready var extra_anim: AnimationNodeAnimation = $Mage/AnimationTree.get_tree_root().get_node('ExtraAnimation')

var player: Player
var aggro: bool = false
var dead: bool = false
var attack_range: float = 15.0
var attacking: bool = false
var fireball_scene: PackedScene = preload("res://assets/models/enemies/mage/Fireball.tscn") 
const TURN_SPEED = 10.0

signal death

func _ready() -> void:
	player = get_parent().find_child("Player")

func hit() -> void:
	health -= 1

func die() -> void:
	death.emit()
	dead = true
	call_deferred("disable_collision")
	extra_anim.animation = "Death_C_Skeletons"
	$Mage/AnimationTree.set("parameters/ExtraAnimOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
func disable_collision() -> void:
	$Mage/CollisionShape3D.disabled = true

func _physics_process(delta: float) -> void:
	movement_logic(delta)

func movement_logic(delta: float) -> void:
	if dead:
		return
	body.velocity = Vector3.ZERO
	if aggro:
		set_move_state("Walking_D_Skeletons")
		var target_dir: Vector3 = (player.global_position - body.global_position).normalized()
		var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
		var target_angle: float = -target_v2.angle() + PI/2
		model.global_rotation.y = rotate_toward(model.global_rotation.y,target_angle,TURN_SPEED * delta)
		if body.global_position.distance_to(player.global_position) >= attack_range:
			body.velocity = Vector3(target_v2.x,0,target_v2.y) * speed
		else:
			set_move_state("Idle")
	else:
		set_move_state("Idle")
	
	if !body.is_on_floor():
		set_move_state("Jump_Idle")
		body.velocity -= Vector3(0,10,0)
	body.move_and_slide()

func _on_vision_circle_body_entered(_body: Node3D) -> void:
	aggro = true
	print("Gained aggro")

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func _on_vision_circle_body_exited(_body: Node3D) -> void:
	aggro = false
	print("Lost aggro")

func attack() -> void:
	$Mage/AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func shoot() -> void:
	var tween = create_tween()
	tween.tween_property(self,"speed",0.0,0.3)
	tween.tween_property(self,"speed",2.0,0.3)
	var target_dir: Vector3 = (player.global_position - body.global_position).normalized()
	var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
	var fireball: Fireball = fireball_scene.instantiate()
	get_parent().add_child(fireball)
	fireball.global_position = $Mage/model/Rig/Skeleton3D/BoneAttachment3D/Skeleton_Staff/Marker3D.global_position
	fireball.direction = target_v2
	

func _on_attack_timer_timeout() -> void:
	if dead:
		return
	if body.global_position.distance_to(player.global_position) <= attack_range:
		attack()
