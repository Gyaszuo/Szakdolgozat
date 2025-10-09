class_name Heart
extends TextureRect

@onready var index: int = int(self.name.right(1))

func update(value) -> void:
	if value >= index * 2:
		texture = load("res://assets/ui_textures/heart_full.png")
	elif value < index * 2 and value >= (index * 2) - 1:
		texture = load("res://assets/ui_textures/heart_half.png")
	else:
		texture = load("res://assets/ui_textures/heart_empty.png")
