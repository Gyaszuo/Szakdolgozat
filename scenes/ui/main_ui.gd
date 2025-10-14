class_name MainUI
extends Control

@onready var health_bar: HealthBar = $HealthBar
@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var menu: Control = $Menu
@onready var key_bar: KeyBar = $KeyBar

func update_health(value: int) -> void:
	health_bar.update_health(value)

func update_keys(value: int) -> void:
	key_bar.update_keys(value)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		open_menu()

func open_menu() -> void:
	if get_tree().paused == false:
		fade_screen(true)
	else:
		fade_screen(false)

func fade_screen(value: bool) -> void:
	var tween = create_tween()
	if value:
		get_tree().paused = true
		tween.tween_property(color_rect,"color",Color(0,0,0,0.5),0.2)
		await tween.finished
		menu.visible = true
	else:
		menu.visible = false
		tween.tween_property(color_rect,"color",Color(0,0,0,0),0.2)
		await tween.finished
		get_tree().paused = false
		
