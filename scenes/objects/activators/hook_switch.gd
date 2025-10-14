class_name HookSwitch
extends Activator
@onready var mesh_instance_3d: MeshInstance3D = $StaticBody3D/MeshInstance3D
@onready var hook_hitbox_component: HookHitboxComponent = $HookHitboxComponent

func switch()-> void:
	activate()
	mesh_instance_3d.mesh.material.albedo_color = Color(0,0.7,0)
	hook_hitbox_component.set_deferred("monitoring",false)
	hook_hitbox_component.set_deferred("monitorable",false)
