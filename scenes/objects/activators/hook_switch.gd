class_name HookSwitch
extends Activator
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var hook_hitbox_component: HookHitboxComponent = $HookHitboxComponent

var activated = false:
	set(value):
		activated = value
		if value:
			mesh_instance_3d.mesh.material.albedo_color = Color(0,0.7,0)
			hook_hitbox_component.set_deferred("monitoring",false)
			hook_hitbox_component.set_deferred("monitorable",false)
		else:
			mesh_instance_3d.mesh.material.albedo_color = Color(1,0,0)
			hook_hitbox_component.set_deferred("monitoring",true)
			hook_hitbox_component.set_deferred("monitorable",true)

func switch()-> void:
	activated = true
	activate()

func load_state(param_activated: bool) -> void:
	if param_activated:
		switch()

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated
	}
	return save_dict
