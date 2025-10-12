@abstract
class_name Activator
extends Node3D

@export var activatables: Array[Activatable]

func activate() -> void:
	for a in activatables:
		a.activate()

func deactivate() -> void:
	for a in activatables:
		a.deactivate()
