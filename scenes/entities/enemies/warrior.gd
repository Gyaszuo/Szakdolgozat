class_name Warrior
extends Node3D

@export var health: int = 6:
	set(value):
		print(health)
		if value >= 0:
			health = value
			if health == 0:
				die()
@export var speed: float = 2.0

@onready var body: CharacterBody3D = $Warrior
@onready var model: Node3D = $Warrior/model
@onready var move_state_machine: AnimationNodeStateMachinePlayback = $Warrior/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var attack_anim: AnimationNodeAnimation = $Warrior/AnimationTree.get_tree_root().get_node('AttackAnimation')
@onready var extra_anim: AnimationNodeAnimation = $Warrior/AnimationTree.get_tree_root().get_node('ExtraAnim')

var player: Player
var aggro: bool = false
var dead: bool = false
var attack_range: float = 2.0
const TURN_SPEED = 10.0

signal death

func _ready() -> void:
	player = get_parent().find_child("Player")
	var rand = randi_range(0,1)
	if rand == 0:
		$"Warrior/model/Rig/Skeleton3D/handslot-r/Skeleton_Axe".visible = true
		$"Warrior/model/Rig/Skeleton3D/handslot-r/Skeleton_Blade".visible = false
	else:
		$"Warrior/model/Rig/Skeleton3D/handslot-r/Skeleton_Axe".visible = false
		$"Warrior/model/Rig/Skeleton3D/handslot-r/Skeleton_Blade".visible = true

func hit() -> void:
	health -= 1

func die() -> void:
	death.emit()
	dead = true
	call_deferred("disable_collision")
	extra_anim.animation = "Death_C_Skeletons"
	$Warrior/AnimationTree.set("parameters/ExtraAnimOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(1.5).timeout
	queue_free()
	
func disable_collision() -> void:
	$Warrior/CollisionShape3D.disabled = true

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
	var attack_type = randi_range(0,2)
	if(attack_type == 0):
		attack_anim.animation = "2H_Melee_Attack_Chop"
	elif(attack_type == 1):
		attack_anim.animation = "2H_Melee_Attack_Slice"
	else:
		attack_anim.animation = "2H_Melee_Attack_Spin"
	$Warrior/AnimationTree.set("parameters/AttackOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func toggle_attack_hitbox(value: bool) -> void:
	$Warrior/model/Area3D/CollisionShape3D.disabled = !value

func toggle_spin_hitbox(value: bool) -> void:
	$Warrior/model/Area3D2/CollisionShape3D.disabled = !value

func _on_attack_timer_timeout() -> void:
	if dead:
		return
	if body.global_position.distance_to(player.global_position) <= attack_range:
		attack()

func _on_area_3d_body_entered(body: Node3D) -> void:
	body.hit()

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	body.hit()
