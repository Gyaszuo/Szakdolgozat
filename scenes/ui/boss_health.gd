class_name BossHealth
extends Control

@onready var progress_bar: ProgressBar = $MarginContainer/ProgressBar
var health = 60

func _physics_process(_delta: float) -> void:
	if health == 40 or health == 20:
		if progress_bar.get_theme_stylebox("fill").bg_color != Color(0,0.8,1,1):
			var tween = create_tween()
			tween.tween_property(progress_bar.get_theme_stylebox("fill"),"bg_color",Color(0,0.8,1,1),0.25)
		

func update_boss_healthbar(value: int):
	progress_bar.value = value
	health = value
	if not value == 40 or  not value == 20:
		var tween = create_tween()
		tween.tween_property(progress_bar.get_theme_stylebox("fill"),"bg_color",Color(0.8,0.8,0.8,1),0.25)
		tween.tween_property(progress_bar.get_theme_stylebox("fill"),"bg_color",Color(0.69,0,0.1,1),0.25)
