extends Activator

var activated = false
@export var one_time = true

func _on_area_3d_body_entered(body: Node3D) -> void:
	activate()
	print("trigger")
	if one_time:
		call_deferred("disable")
		
func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true

func load_state(activated: bool) -> void:
	if activated:
		_on_area_3d_body_entered(null)

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated
	}
	return save_dict
