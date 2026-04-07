class_name HeavyPressurePlate
extends Activator

var activated = false
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_area_3d_area_entered(_area: Area3D) -> void:
	if not activated:
		activated = true
		print("HeavyPressurePlate activated")
		activate()
		var tween = create_tween()
		tween.tween_property(mesh,"position",Vector3(0,-0.19,0),0.5)

func load_state(param_activated: bool) -> void:
	if param_activated:
		_on_area_3d_area_entered(null)

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated
	}
	return save_dict
