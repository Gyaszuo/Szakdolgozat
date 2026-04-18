class_name MainUI
extends Control

@onready var health_bar: HealthBar = $HealthBar
@onready var treasure_counter: Control = $TreasureCounter
@onready var color_rect: ColorRect = $MarginContainer/ColorRect
@onready var menu: Control = $Menu
@onready var key_bar: KeyBar = $KeyBar

signal quit
signal boss_health(value: bool)

func update_health(value: int) -> void:
	health_bar.update_health(value)

func update_keys(value: int) -> void:
	key_bar.update_keys(value)

func update_treasure(value: int) -> void:
	treasure_counter.update_treasure(value)
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		boss_health.emit(false)
		open_menu()

func open_menu() -> void:
	if get_tree().paused == false:
		fade_screen(true)
	else:
		fade_screen(false)
		boss_health.emit(true)

func fade_screen(value: bool) -> void:
	var tween = create_tween()
	if value:
		get_tree().paused = true
		tween.tween_property(color_rect,"color",Color(0,0,0,0.5),0.2)
		await tween.finished
		menu.visible = true
		menu._ready()
	else:
		menu.visible = false
		tween.tween_property(color_rect,"color",Color(0,0,0,0),0.2)
		await tween.finished
		get_tree().paused = false

func show_title(title: String) -> void:
	print(title)
	$LevelTitle/Label.text = title
	var tween = create_tween()
	await tween.tween_method(title_font_color_change,Color(1,1,1,0),Color(1,1,1,1),2).finished
	await get_tree().create_timer(3).timeout
	tween = create_tween()
	await tween.tween_method(title_font_color_change,Color(1,1,1,1),Color(1,1,1,0),2).finished
	$LevelTitle/Label.text = ""

func title_font_color_change(color: Color):
	$LevelTitle/Label.add_theme_color_override("font_color", color)

func quit_game() -> void:
	quit.emit()
