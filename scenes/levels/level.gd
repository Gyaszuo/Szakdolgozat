@abstract
class_name Level
extends Node3D

@export var player: Player
@export var hook_group: Node3D

var hook_scene: PackedScene = preload("res://scenes/entities/player/hook.tscn")

func _ready() -> void:
	player.connect("shoot_hook",shoot_hook)

func shoot_hook(direction: Vector3):
	if hook_group.get_child_count() == 0:
		var hook_instance = hook_scene.instantiate()
		hook_group.add_child(hook_instance)
		hook_instance.global_position = player.hook_launch_point.global_position
		hook_instance.direction = direction
		hook_instance.player_position = player.global_position
		hook_instance.player = player
