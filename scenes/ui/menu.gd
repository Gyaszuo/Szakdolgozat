extends Control

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().quit_to_menu()
