class_name KeyBar
extends Control

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer
@onready var current_keys: int = h_box_container.get_children().size()

func update_keys(value: int) -> void:
	for i in range(h_box_container.get_children().size()):
		h_box_container.remove_child(h_box_container.get_children().pop_back()) 
	for i in range(value):
		var key = load("res://scenes/ui/Key.tscn").instantiate()
		h_box_container.add_child(key)
	current_keys = h_box_container.get_children().size()
