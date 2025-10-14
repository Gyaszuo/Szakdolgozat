class_name Switch
extends Activator

var activated: bool = false
@onready var stick: MeshInstance3D = $Base/Stick
@onready var area_3d: Area3D = $Area3D

func _on_area_3d_area_entered(area: Area3D) -> void:
	var rotation_tween = create_tween()
	var color_tween = create_tween()
	area_3d.set_deferred("monitoring",false)
	area_3d.set_deferred("monitorable",false)
	if not activated:
		rotation_tween.tween_property(stick,"rotation",Vector3(0,0,deg_to_rad(-30)),0.5)
		color_tween.tween_property(stick.mesh.material,"albedo_color",Color(0,0.7,0),0.5)	
		await rotation_tween.finished
		activated = true;
		activate()
	else:
		rotation_tween.tween_property(stick,"rotation",Vector3(0,0,deg_to_rad(30)),0.5)
		color_tween.tween_property(stick.mesh.material,"albedo_color",Color(1,0,0),0.5)
		await rotation_tween.finished
		activated = false;
		deactivate()
	area_3d.set_deferred("monitoring",true)
	area_3d.set_deferred("monitorable",true)
