@abstract
class_name Activatable
extends Node3D

@export var activators: Array[Activator]
@onready var activation_req: int = activators.size()
var current_activations: int = 0:
	set(value):
		if value >= 0:
			current_activations = value
		print("Current activations: ",current_activations)
		print("Activated: ",!activated)
		if current_activations == activation_req and !activated:
			print("trigger")
			trigger()
		elif current_activations != activation_req and activated:
			print("untrigger")
			untrigger()
var activated: bool = false
	
func activate() -> void:
	print("activate")
	current_activations += 1

func deactivate() -> void:
	print("deactivate")
	current_activations -= 1

@abstract
func trigger() -> void

@abstract
func untrigger() -> void
