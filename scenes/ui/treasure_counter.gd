extends Control

@onready var label: Label = $Label


func update_treasure(value: int) -> void:
	label.text = String.num_int64(value)
