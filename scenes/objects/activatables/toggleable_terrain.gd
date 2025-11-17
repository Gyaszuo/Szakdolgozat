class_name ToggleableTerrain
extends Activatable

@export var preActivated: bool = false

func trigger() -> void:
	activated = true
	$StaticBody3D/CollisionShape3D.disabled = true
	var tween = create_tween()
	tween.tween_method(self.fade,1.0,0.25,1.0)
	

func untrigger() -> void:
	activated = false
	$StaticBody3D/CollisionShape3D.disabled = false
	var tween = create_tween()
	tween.tween_method(self.fade,0.25,1.0,1.0)

func fade(value: float) -> void:
	$Mesh.mesh.material.albedo_color.a = value
