extends Control

signal quit

func _on_quit_pressed() -> void:
	get_tree().paused = false
	quit.emit()

func _ready() -> void:
	if visible:
		$PanelContainer/VBoxContainer/Quit.grab_focus()
