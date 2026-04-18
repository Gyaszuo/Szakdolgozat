class_name MainMenu
extends Control

signal continue_game
signal level_select(level: String)

func _ready() -> void:
	if visible:
		$MarginContainer/VBoxContainer/VBox/StartGame.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_start_game_pressed() -> void:
	level_select.emit("res://scenes/levels/Level1/Level1.tscn")

func _on_continue_game_pressed() -> void:
	continue_game.emit()

func _on_test_level_pressed() -> void:
	level_select.emit("res://scenes/test/test_level.tscn")

func enable_debug() -> void:
	$MarginContainer2/VBoxContainer2.visible = true

func _on_level_4_pressed() -> void:
	level_select.emit("res://scenes/levels/Level4/Level4.tscn")

func _on_level_3_pressed() -> void:
	level_select.emit("res://scenes/levels/Level3/Level3.tscn")

func _on_level_2_pressed() -> void:
	level_select.emit("res://scenes/levels/Level2/Level2.tscn")

func _on_level_1_pressed() -> void:
	level_select.emit("res://scenes/levels/Level1/Level1.tscn")
