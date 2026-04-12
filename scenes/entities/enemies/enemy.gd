@abstract
class_name Enemy
extends Node3D

var health:
	set(value):
		if value >= 0:
			health = value
			if health == 0:
				die()
var speed
var aggro: bool = false
var pre_aggro: bool = false
var dead: bool = false
var attack_range: float = 2.0
var player: Player
var attacking: bool = false
var aggro_cast_scene: PackedScene = preload("res://scenes/entities/player/AggroCast.tscn")
var aggro_cast
var walk_anim = "Walking_D_Skeletons"
@onready var body: CharacterBody3D = $Body
@onready var model: Node3D = $Body/model
@onready var hitbox: CollisionShape3D = $Body/CollisionShape3D
@onready var marker: Marker3D = $Body/Marker3D
@onready var attack_timer: Timer = $Body/AttackTimer
@onready var vision_timer: Timer = $Body/VisionTimer
@onready var animation_tree: AnimationTree = $Body/AnimationTree
@onready var move_state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/MoveStateMachine/playback")
@onready var attack_anim: AnimationNodeAnimation = animation_tree.get_tree_root().get_node('AttackAnimation')
@onready var extra_anim: AnimationNodeAnimation = animation_tree.get_tree_root().get_node('ExtraAnimation') 

const TURN_SPEED = 10.0

signal death

func _physics_process(delta: float) -> void:
	movement_logic(delta)
	if aggro_cast:
		aggro_cast.target_position = player.to_local(marker.global_position)
		if not aggro_cast.is_colliding() && pre_aggro:
			aggro = true
			vision_timer.stop()
		if aggro_cast && aggro:
			if vision_timer.is_stopped():
				vision_timer.start()

func movement_logic(delta: float) -> void:
	if dead or attacking:
		return
	if aggro:
		set_move_state(walk_anim)
		var target_dir: Vector3 = (player.global_position - body.global_position).normalized()
		var target_v2: Vector2 = Vector2(target_dir.x,target_dir.z)
		var target_angle: float = -target_v2.angle() + PI/2
		model.global_rotation.y = rotate_toward(model.global_rotation.y,target_angle,TURN_SPEED * delta)
		if body.global_position.distance_to(player.global_position) > attack_range:
			body.velocity = Vector3(target_v2.x,0,target_v2.y) * speed
		else:
			body.velocity = Vector3.ZERO
			set_move_state("Idle")
			if dead or player == null or attacking:
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

func _on_vision_circle_body_entered(_body: Node3D) -> void:
	if aggro:
		return
	aggro_cast = aggro_cast_scene.instantiate()
	player.aggro_cast.add_child(aggro_cast)
	await get_tree().create_timer(0.1).timeout
	pre_aggro = true

func set_move_state(state_name: String) -> void:
	move_state_machine.travel(state_name)

func _on_vision_circle_body_exited(_body: Node3D) -> void:
	aggro = false
	pre_aggro = false
	player.aggro_cast.remove_child(aggro_cast)
	aggro_cast = null

@abstract
func attack()

func hit() -> void:
	health -= 1

func disable_collision() -> void:
	hitbox.disabled = true

func toggle_attack_hitbox(value: bool) -> void:
	model.get_child(2).get_child(0).disabled = !value
	attacking = value	

func _on_area_3d_body_entered(enter_body: Node3D) -> void:
	enter_body.hit()

func die() -> void:
	death.emit()
	dead = true
	call_deferred("disable_collision")
	extra_anim.animation = "Death_C_Skeletons"
	animation_tree.set("parameters/ExtraAnimOneShot/request",AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(1.5).timeout
	queue_free()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"name" : name,
		"health" : health,
		"speed" : speed,
		"pos_x" : body.global_position.x,
		"pos_y" : body.global_position.y,
		"pos_z" : body.global_position.z,
		"rot_x" : body.global_rotation.x,
		"rot_y" : global_rotation.y,
		"rot_z" : global_rotation.z,
		"scale_x" : body.scale.x,
		"scale_y" : body.scale.y,
		"scale_z" : body.scale.z
	}
	return save_dict

func init():
	attack_timer.wait_time = randf_range(1.5,2)
