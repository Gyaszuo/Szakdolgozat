class_name EndScreen
extends Control

signal main_menu

func set_completion(total_treasure: int) -> void:
	var treasure_label: Label = $MarginContainer/VBoxContainer/MarginContainer3/HBoxContainer/TreasureCounter
	treasure_label.text = String.num_int64(total_treasure)

func _on_menu_button_pressed() -> void:
	main_menu.emit()

func _ready() -> void:
	if visible:
		$MarginContainer/VBoxContainer/MarginContainer2/MenuButton.grab_focus()
