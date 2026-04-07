extends Activator

var activated = false
@export var one_time = true

func _on_area_3d_body_entered(_body: Node3D) -> void:
	if activated and one_time:
		return
	activated = true
	if one_time:
		call_deferred("disable")
	activate()
	
func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true
	
func enable() -> void:
	$Area3D/CollisionShape3D.disabled = false

func load_state(param_activated: bool) -> void:
	if param_activated:
		_on_area_3d_body_entered(null)

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated,
		"one_time": one_time
	}
	return save_dict


func _on_area_3d_body_exited(_body: Node3D) -> void:
	if not one_time:
		activated = false
