class_name Door
extends Activatable

func trigger() -> void:
	if not activated:
		var tween = create_tween()
		tween.tween_property(self,"rotation",Vector3(0,deg_to_rad(90),0),0.5)
		activated = true

func untrigger() -> void:
	if activated:
		var tween = create_tween()
		tween.tween_property(self,"rotation",Vector3(0,0,0),0.5)
		activated = false
