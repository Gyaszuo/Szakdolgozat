class_name Door
extends Activatable

@onready var init_rotation = rotation.y

func trigger() -> void:
	if not activated:
		var tween = create_tween()
		tween.tween_property(self,"rotation",Vector3(0,deg_to_rad(90) + init_rotation,0),0.5)
		activated = true

func untrigger() -> void:
	if activated:
		var tween = create_tween()
		tween.tween_property(self,"rotation",Vector3(0,0 + init_rotation,0),0.5)
		activated = false
