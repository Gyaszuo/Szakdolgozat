class_name KeyBar
extends Control

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var current_keys: int = h_box_container.get_children().size()

func update_keys(value: int) -> void:
	if value < current_keys:
		h_box_container.remove_child(h_box_container.get_children().pop_back())
	elif value > current_keys:
		var key = load("res://scenes/ui/Key.tscn").instantiate()
		h_box_container.add_child(key)
	current_keys = h_box_container.get_children().size()
	print(current_keys)
