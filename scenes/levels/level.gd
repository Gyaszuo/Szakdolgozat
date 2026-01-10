@abstract
class_name Level
extends Node3D

@onready var player: Player
@export var next_level_num: int = 1

var hook_scene: PackedScene = preload("res://scenes/entities/player/hook.tscn")

func shoot_hook(direction: Vector3):
	if $Hooks.get_child_count() == 0:
		var hook_instance = hook_scene.instantiate()
		$Hooks.add_child(hook_instance)
		hook_instance.global_position = player.hook_launch_point.global_position
		hook_instance.direction = direction
		hook_instance.player = player

func next_level():
	var next_level_string =  "res://scenes/levels/level" + String.num(next_level_num) + ".tscn"
	get_parent().get_parent().treasure = player.treasure
	get_parent().get_parent().load_next_level(next_level_string)

func save():
	return get_scene_file_path()

func init():
	print("init")
	for i in $Entities.get_children():
		if i is Player: player = i
	player.connect("shoot_hook",shoot_hook)
	for child in $Entities.get_children():
		if child.has_method("init"):
			child.player = player
