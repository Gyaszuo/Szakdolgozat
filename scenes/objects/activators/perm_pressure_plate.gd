class_name PermPressurePlate
extends Activator

var activated = false
@onready var mesh: MeshInstance3D = $MeshInstance3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	if not activated:
		activated = true
		print("PermPressurePlate activated")
		activate()
		var tween = create_tween()
		tween.tween_property(mesh,"position",Vector3(0,-0.19,0),0.5)
