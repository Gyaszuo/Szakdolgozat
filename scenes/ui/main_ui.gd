class_name MainUI
extends Control

@onready var health_bar: HealthBar = $HealthBar
@onready var color_rect: ColorRect = $MarginContainer/ColorRect

func update_health(value: int) -> void:
	health_bar.update_health(value)
