class_name TempPlatform
extends Node3D

@export var disappear_time = 1.0
@export var reappear_time = 1.0
@onready var mesh1: MeshInstance3D = $floor_dirt_large_rocky/floor_dirt_large_rocky
@onready var mesh2: MeshInstance3D = $floor_dirt_large_rocky/floor_dirt_large_rocky/floor_dirt_large_rocky

func _ready() -> void:
	$Timers/DisappearTimer.wait_time = disappear_time
	$Timers/ReappearTimer.wait_time = reappear_time

func _on_disappear_timer_timeout() -> void:
	$StaticBody3D/CollisionShape3D.disabled = true
	$Area3D/CollisionShape3D.disabled = true
	var arr_mesh1: ArrayMesh = mesh1.mesh
	arr_mesh1.surface_get_material(0).albedo_color.a = 0.25
	var arr_mesh2: ArrayMesh = mesh2.mesh
	arr_mesh2.surface_get_material(0).albedo_color.a = 0.25
	$Timers/ReappearTimer.start()
	
func _on_reappear_timer_timeout() -> void:
	$StaticBody3D/CollisionShape3D.disabled = false
	$Area3D/CollisionShape3D.disabled = false
	var arr_mesh1: ArrayMesh = mesh1.mesh
	arr_mesh1.surface_get_material(0).albedo_color.a = 1
	var arr_mesh2: ArrayMesh = mesh2.mesh
	arr_mesh2.surface_get_material(0).albedo_color.a = 1
	
func _on_area_3d_body_entered(_body: Node3D) -> void:
	$Timers/DisappearTimer.start()
