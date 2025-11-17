class_name TempPlatform
extends Node3D

@export var disappear_time = 1.0
@export var reappear_time = 1.0

func _ready() -> void:
	$Timers/DisappearTimer.wait_time = disappear_time
	$Timers/ReappearTimer.wait_time = reappear_time

func _on_disappear_timer_timeout() -> void:
	visible = false
	$StaticBody3D/CollisionShape3D.disabled = true
	$Area3D/CollisionShape3D.disabled = true
	$Timers/ReappearTimer.start()
	
func _on_reappear_timer_timeout() -> void:
	visible = true
	$StaticBody3D/CollisionShape3D.disabled = false
	$Area3D/CollisionShape3D.disabled = false
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	$Timers/DisappearTimer.start()
