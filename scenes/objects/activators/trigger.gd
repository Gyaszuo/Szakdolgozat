extends Activator

var activated = false
@export var one_time = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	activated = true
	if one_time:
		call_deferred("disable")
	activate()
	
func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true
	
func enable() -> void:
	$Area3D/CollisionShape3D.disabled = false

func load_state(activated: bool) -> void:
	if activated:
		_on_area_3d_body_entered(null)

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated
	}
	return save_dict


func _on_area_3d_body_exited(body: Node3D) -> void:
	if not one_time:
		activated = false
