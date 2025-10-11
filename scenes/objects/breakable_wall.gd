class_name BreakableWall
extends Node3D

@export var hp: int = 3

func hit() -> void:
	hp -= 1
	if hp <= 0:
		queue_free()
