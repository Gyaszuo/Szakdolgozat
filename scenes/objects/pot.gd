class_name Pot
extends Node3D

var coin_scene: PackedScene = preload("res://scenes/objects/collectibles/Coin.tscn")
@export var coin_count: int = 3

func _ready() -> void:
	randomize()

func hit() -> void:
	for i in range(coin_count):
		var coin: Coin = coin_scene.instantiate()
		get_parent().add_child(coin)
		coin.global_position = $Marker3D.global_position
		coin.spawn(global_position + Vector3(randf_range(-1.0,1.0),1.25,randf_range(-1.0,1.0)))
	queue_free()

func save() -> Dictionary:
	var save_dict = {
		"filename" : get_scene_file_path(),
		"node_name" : name,
		"parent" : get_parent().get_path(),
		"pos_x" : global_position.x,
		"pos_y" : global_position.y,
		"pos_z" : global_position.z,
		"coin_count" : coin_count,
		"rot_x" : global_rotation.x,
		"rot_y" : global_rotation.y,
		"rot_z" : global_rotation.z,
		"scale_x" : scale.x,
		"scale_y" : scale.y,
		"scale_z" : scale.z
	}
	return save_dict

func get_value():
	return coin_count
