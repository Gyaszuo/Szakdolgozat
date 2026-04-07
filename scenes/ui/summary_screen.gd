class_name SummaryScreen
extends Control

var level: String

signal next_level(level: String)

func set_completion(total_treasure: int,remaining_treasure: int) -> void:
	var label: Label = $MarginContainer/VBoxContainer/HBoxContainer/CompletionCounter
	label.text = String.num_int64(remaining_treasure) + "/" + String.num_int64(total_treasure)

func _on_next_level_button_pressed() -> void:
	next_level.emit(level)
