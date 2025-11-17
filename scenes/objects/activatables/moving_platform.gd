class_name MovingPlatform
extends Activatable

@export var path: PathFollow3D
@export var preActivated: bool = false
@export var speed: float = 1.0

func _physics_process(delta: float) -> void:
	if (preActivated and not activated) or (not preActivated and activated):
		path.progress += speed * delta

func trigger() -> void:
	activated = true

func untrigger() -> void:
	activated = false
