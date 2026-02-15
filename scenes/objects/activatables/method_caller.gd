class_name MethodCaller
extends Activatable

@export var callable: String

func trigger() -> void:
	get_parent().get_parent().call_deferred(callable)
	untrigger()

func untrigger() -> void:
	current_activations = 0
