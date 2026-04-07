class_name Lock
extends Activator

var activated: bool = false

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.keys > 0:
		body.keys -= 1
		activated = true
		activate()
		visible = false
		call_deferred("disable")

func disable() -> void:
	$Area3D/CollisionShape3D.disabled = true

func load_state(param_activated: bool) -> void:
	if param_activated:
		var player = PseudoPlayer.new()
		player.keys = 1
		_on_area_3d_body_entered(player)

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated
	}
	return save_dict
