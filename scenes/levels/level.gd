@abstract
class_name Level
extends Node3D

@onready var player: Player
@onready var entities: Node3D = $Entities
@onready var hooks: Node3D = $Hooks
@onready var collectibles: Node3D = $Collectibles
@onready var objects: Node3D = $Objects
@onready var level_geometry: Node3D = $LevelGeometry
@onready var respawn_timer: Timer = $RespawnTimer
@export var next_level_num: int = 1
@export var level_name: String

var hook_scene: PackedScene = preload("res://scenes/entities/player/hook.tscn")
signal save_treasure(treasure: int)
signal load_next_level(next_level_string: String)
signal quit

func shoot_hook(direction: Vector3):
	if hooks.get_child_count() == 0:
		var hook_instance = hook_scene.instantiate()
		hooks.add_child(hook_instance)
		hook_instance.global_position = player.hook_launch_point.global_position
		hook_instance.direction = direction
		hook_instance.player = player

func next_level():
	var next_level_string =  "res://scenes/levels/Level" + String.num(next_level_num,0) + "/Level" + String.num(next_level_num,0) + ".tscn"
	save_treasure.emit(player.treasure)
	load_next_level.emit(next_level_string)

func save():
	return get_scene_file_path()

func init():
	for i in entities.get_children():
		if i is Player: player = i
	if not player.is_connected("shoot_hook",shoot_hook):
		player.connect("shoot_hook",shoot_hook)
	if not player.is_connected("quit",quit_game):
		player.connect("quit",quit_game)
	for child in entities.get_children():
		if child.has_method("init") and child is not Box:
			child.player = player
			child.init()
			if child.has_signal("death"):
				child.connect("death",update_kill_switches)
	player.main_ui.show_title(level_name)
	respawn_timer.start()
	await respawn_timer.timeout
	for child in objects.get_children():
		if child is RespawnPlatform:
			child.enabled = true

func call_method(callable: String):
	call_deferred(callable)

func calc_max_treasure() -> int:
	var sum = 0
	for node in collectibles.get_children():
		sum += node.get_value()
	return sum

func calc_max_crests() -> int:
	var sum = 0
	for node in collectibles.get_children():
		if node is Crest:
			sum += 1
	return sum

func update_kill_switches():
	for i in $Objects.get_children():
		if i is EnemyKillSwitch:
			i.update()

func quit_game() -> void:
	quit.emit()
