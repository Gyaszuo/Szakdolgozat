class_name Hook
extends Area3D

var direction: Vector3
var speed: float = 10.0
var player_position: Vector3
var player: Player
var hook_started: bool = false
var stuck: bool = false

@onready var chain: Node3D = $Chain
@onready var chain_end: Marker3D = $Chain/Marker3D

func _process(delta: float) -> void:
	if hook_started and !player.is_hooking:
		queue_free()

func _physics_process(delta: float) -> void:
	position += Vector3(direction.x,direction.y,direction.z) * speed * delta
	if not stuck: position = chain_end.global_position
	update_chain()
	if position.distance_to(player_position) > 20.0:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	queue_free()

func stop_movement():
	speed = 0.0

func _on_area_entered(area: Area3D) -> void:
	stop_movement()
	stuck = true
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)
	area.connect("hook_hit",hook_hit)

func hook_hit(variant: HookVariants.variants,global_pos: Vector3):
	if variant == HookVariants.variants.PULL:
		player.travel_hook(global_pos)
		hook_started = true
	elif variant == HookVariants.variants.SWITCH:
		queue_free()
	else:
		queue_free()

func update_chain():
	look_at(global_transform.origin + direction,Vector3.UP)
	chain.visible = true
	var dist = player.hook_launch_point.global_position.distance_to(global_position)
	chain.global_position = player.hook_launch_point.global_position
	chain.look_at(global_transform.origin + direction,Vector3.UP)
	chain.scale = Vector3(1,1,dist)
