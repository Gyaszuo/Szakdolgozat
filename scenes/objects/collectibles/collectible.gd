@abstract
class_name Collectible
extends Node3D

@export var spin_speed: float = 0.05

@abstract
func _on_hitbox_body_entered(body: Node3D) -> void

func _physics_process(delta: float) -> void:
	rotation.y += spin_speed
