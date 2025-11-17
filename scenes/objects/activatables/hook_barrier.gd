class_name HookBarrier
extends Activatable

@export var preActivated: bool = false

func _ready() -> void:
	if preActivated:
		$StaticBody3D/CollisionShape3D.disabled = true
		var tween = create_tween()
		tween.tween_method(self.fade,0.25,0,1.0)

func trigger() -> void:
	if not preActivated:
		activated = true
		$StaticBody3D/CollisionShape3D.disabled = true
		var tween = create_tween()
		tween.tween_method(self.fade,0.25,0.0,1.0)
	else:
		activated = true
		$StaticBody3D/CollisionShape3D.disabled = false
		var tween = create_tween()
		tween.tween_method(self.fade,0.25,0.0,1.0)

func untrigger() -> void:
	if not preActivated:
		activated = false
		$StaticBody3D/CollisionShape3D.disabled = false
		var tween = create_tween()
		tween.tween_method(self.fade,0.0,0.25,1.0)
	else:
		activated = false
		$StaticBody3D/CollisionShape3D.disabled = true
		var tween = create_tween()
		tween.tween_method(self.fade,0.25,0.0,1.0)

func fade(value: float) -> void:
	$Mesh.mesh.material.albedo_color.a = value
