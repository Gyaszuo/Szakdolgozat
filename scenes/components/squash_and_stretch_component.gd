class_name SqashAndStretchComponent
extends Node

@export var skin: Node3D

var squash_and_stretch: float = 1.0:
	set(value):
		squash_and_stretch = value
		var negative = 1.0 + (1.0 - squash_and_stretch)
		skin.scale = Vector3(negative,squash_and_stretch,negative)

func do_squash_and_stretch(value: float,dur: float = 0.1):
	var tween = create_tween()
	tween.tween_property(self,"squash_and_stretch",value,dur)
	tween.tween_property(self,"squash_and_stretch",1.0,dur * 1.8).set_ease(Tween.EASE_OUT)
