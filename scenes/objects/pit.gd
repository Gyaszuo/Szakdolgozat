class_name Pit
extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		var tween = create_tween()
		tween.tween_property(body.main_ui.color_rect,"color",Color(0,0,0,1),0.1)
		await tween.finished
		body.hit()
		body.fall()
		if body.health > 0:
			tween = create_tween()
			tween.tween_property(body.main_ui.color_rect,"color",Color(0,0,0,0),0.2)
	else:
		body.queue_free()
