class_name SummaryScreen
extends Control

var level: String

signal next_level(level: String)

func set_completion(total_treasure: int,remaining_treasure: int,total_crests: int,remaining_crests: int) -> void:
	var treasure_label: Label = $MarginContainer/VBoxContainer/MarginContainer3/HBoxContainer/TreasureCompletionCounter
	treasure_label.text = String.num_int64(remaining_treasure) + "/" + String.num_int64(total_treasure)
	var crest_label: Label = $MarginContainer/VBoxContainer/MarginContainer4/HBoxContainer2/CrestCompletionCounter
	crest_label.text = String.num_int64(remaining_crests) + "/" + String.num_int64(total_crests)

func _on_next_level_button_pressed() -> void:
	next_level.emit(level)

func _ready() -> void:
	if visible:
		$MarginContainer/VBoxContainer/MarginContainer2/NextLevelButton.grab_focus()
