extends Control

signal quit

func _on_quit_pressed() -> void:
	get_tree().paused = false
	print("quit in Menu")
	quit.emit()
