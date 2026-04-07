class_name TempPressurePlate
extends Activator

var activated = false
var entered_body_number: int = 0
var load_body_number: int = 0
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_area_3d_body_entered(_body: Node3D) -> void:
	entered_body_number += 1
	if not activated:
		activated = true
		print("TempPressurePlate activated")
		activate()
		var tween = create_tween()
		tween.tween_property(mesh,"position",Vector3(0,-0.19,0),0.5)


func _on_area_3d_body_exited(_body: Node3D) -> void:
	entered_body_number -= 1
	if activated and entered_body_number == 0:
		activated = false
		print("TempPressurePlate deactivated")
		deactivate()
		var tween = create_tween()
		tween.tween_property(mesh,"position",Vector3(0,0,0),0.5)

func load_state(param_activated: bool) -> void:
	if param_activated:
		for i in range(load_body_number):
			_on_area_3d_body_entered(null)

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated,
		"load_body_number": entered_body_number
	}
	return save_dict
