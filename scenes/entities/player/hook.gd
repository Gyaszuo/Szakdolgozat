class_name Hook
extends Area3D

var direction: Vector3
var speed: float = 30.0
var player_position: Vector3
var player: Player
var hook_started: bool = false
var switching: bool = false

@onready var chain: Node3D = $Chain
@onready var chain_end: Marker3D = $Chain/Marker3D

func _process(delta: float) -> void:
	if hook_started and !player.is_hooking and !switching:
		queue_free()

func _physics_process(delta: float) -> void:
	position += Vector3(direction.x,direction.y,direction.z) * speed * delta
	update_chain()
	if position.distance_to(player_position) > 20.0:
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	queue_free()

func stop_movement():
	speed = 0.0

func _on_area_entered(area: Area3D) -> void:
	stop_movement()
	set_deferred("monitoring",false)
	set_deferred("monitorable",false)
	area.connect("hook_hit",hook_hit)

func hook_hit(variant: HookVariants.variants,global_pos: Vector3,parent: Node3D):
	if variant == HookVariants.variants.PULL:
		player.travel_hook(global_pos)
		hook_started = true
		player.is_hooking = true
	elif variant == HookVariants.variants.SWITCH:
		hook_started = true
		switching = true
		await get_tree().create_timer(0.5).timeout
		parent.switch()
		hook_started = false
		switching = false
		queue_free()
	else:
		queue_free()

func update_chain():
	look_at(global_transform.origin + direction,Vector3.UP)
	chain.visible = true
	var dist = player.hook_launch_point.global_position.distance_to(global_position)
	chain.global_position = player.hook_launch_point.global_position
	chain.look_at(global_transform.origin + chain.global_position.direction_to(global_position),Vector3.UP)
	chain.scale = Vector3(1,1,dist)
