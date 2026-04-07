class_name ToggleableTerrain
extends Activatable

@export var preActivated: bool = false
@export var mesh: MeshInstance3D
@export var collision: CollisionShape3D
@export var alphaAmount: float = 0.25

func _ready() -> void:
	if preActivated:
		call_deferred("collision_change",true)
		var tween = create_tween()
		tween.tween_method(self.fade,1.0,alphaAmount,1.0)

func trigger() -> void:
	if not preActivated:
		activated = true
		call_deferred("collision_change",true)
		var tween = create_tween()
		tween.tween_method(self.fade,1.0,alphaAmount,1.0)
	else:
		activated = true
		call_deferred("collision_change",false)
		var tween = create_tween()
		tween.tween_method(self.fade,alphaAmount,1.0,1.0)

func untrigger() -> void:
	if not preActivated:
		activated = false
		call_deferred("collision_change",false)
		var tween = create_tween()
		tween.tween_method(self.fade,alphaAmount,1.0,1.0)
	else:
		activated = false
		call_deferred("collision_change",true)
		var tween = create_tween()
		tween.tween_method(self.fade,1.0,alphaAmount,1.0)

func fade(value: float) -> void:
	var arr_mesh: ArrayMesh = mesh.mesh
	arr_mesh.surface_get_material(0).albedo_color.a = value

func collision_change(value: bool) -> void:
	collision.disabled = value
