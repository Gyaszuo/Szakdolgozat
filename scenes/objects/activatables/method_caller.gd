class_name MethodCaller
extends Activatable

signal method_call()

func trigger() -> void:
	method_call.emit()
	untrigger()

func untrigger() -> void:
	current_activations = 0
