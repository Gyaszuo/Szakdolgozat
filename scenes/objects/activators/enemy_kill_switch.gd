class_name EnemyKillSwitch
extends Activator

var activated: bool = false
var enabled: bool = false
var killed_enemies: int = 0
@export var required_enemies: int

func load_state(activated: bool) -> void:
	if activated:
		update()

func update() -> void:
	if enabled:
		killed_enemies += 1
		print(killed_enemies)
	if killed_enemies == required_enemies:
		print("activate")
		activate()

func save() -> Dictionary:
	var save_dict = {
		"name" : name,
		"activated" : activated,
		"killed_enemies" : killed_enemies,
		"enabled": enabled
	}
	return save_dict
