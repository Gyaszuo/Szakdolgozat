@abstract
class_name Activatable
extends Node3D

@export var activators: Array[Activator]
@onready var activation_req: int = activators.size()
var current_activations: int = 0:
	set(value):
		if value >= 0:
			current_activations = value
		if current_activations == activation_req and not activated:
			trigger()
		elif current_activations != activation_req and activated:
			print("deactivated")
			untrigger()
var activated: bool = false
	
func activate() -> void:
	current_activations += 1

func deactivate() -> void:
	current_activations -= 1

@abstract
func trigger() -> void

@abstract
func untrigger() -> void
