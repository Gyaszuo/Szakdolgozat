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
		coin.spawn(global_position + Vector3(randf_range(-1.0,1.0),0.15,randf_range(-1.0,1.0)))
	queue_free()

	
