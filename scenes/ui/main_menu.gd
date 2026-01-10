class_name MainMenu
extends Control

func toggle(value: bool):
	visible = value
	$VBox/Button.disabled = !value
	$VBox/Button2.disabled = !value

func _on_button_2_pressed() -> void:
	get_tree().quit()

func _on_button_pressed() -> void:
	get_parent().start_new_game()


func _on_button_3_pressed() -> void:
	get_parent().load_game()
