class_name HookSwitch
extends Activator
@onready var mesh_instance_3d: MeshInstance3D = $StaticBody3D/MeshInstance3D
@onready var hook_hitbox_component: HookHitboxComponent = $HookHitboxComponent

var activated = false:
	set(value):
		if value:
			mesh_instance_3d.mesh.material.albedo_color = Color(0,0.7,0)
			hook_hitbox_component.set_deferred("monitoring",false)
			hook_hitbox_component.set_deferred("monitorable",false)

func switch()-> void:
	activate()
	activated = true

func load_state(activated: bool) -> void:
	if activated:
		switch()

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated
	}
	return save_dict
