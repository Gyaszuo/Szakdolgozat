class_name BoxBarrier
extends Activatable

@export var preActivated: bool = false
@export var invisible: bool = false

func _ready() -> void:
	if preActivated:
		$StaticBody3D/CollisionShape3D.disabled = true
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.25,0,1.0)
	if invisible:
		fade(0)

func trigger() -> void:
	if not preActivated:
		activated = true
		$StaticBody3D/CollisionShape3D.disabled = true
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.25,0.0,1.0)
	else:
		activated = true
		$StaticBody3D/CollisionShape3D.disabled = false
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.0,0.25,1.0)

func untrigger() -> void:
	if not preActivated:
		activated = false
		$StaticBody3D/CollisionShape3D.disabled = false
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.0,0.25,1.0)
	else:
		activated = false
		$StaticBody3D/CollisionShape3D.disabled = true
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.25,0.0,1.0)

func fade(value: float) -> void:
	$Mesh.mesh.material.albedo_color.a = value
