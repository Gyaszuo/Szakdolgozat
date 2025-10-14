class_name HookHitboxComponent
extends Area3D

@export var collision_shape: CollisionShape3D
@export var snap_marker: Marker3D
@export var variant: HookVariants.variants = HookVariants.variants.PULL

signal hook_hit(pull_player: bool,global_pos: Vector3,parent: Node3D)

func _on_area_entered(area: Area3D) -> void:
	area.global_position = snap_marker.global_position
	await get_tree().create_timer(0.01).timeout
	hook_hit.emit(variant,snap_marker.global_position,get_parent())
