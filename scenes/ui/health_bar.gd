class_name HealthBar
extends Control

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer

func update_health(value: int) -> void:
	for heart in h_box_container.get_children():
		heart.update(value)
