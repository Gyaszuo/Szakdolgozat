class_name Main
extends Node

var treasure: int
var total_treasure: int
var total_crests: int
const DEBUG_UNLOCK_SEQUENCE = ["S","Z","A","K","D","O","L","G","O","Z","A","T"]
var debug_mode = false:
	set(value):
		debug_mode = value
		if(value):
			$MainMenu.enable_debug()
var current_sequence = []

const handled_keys = [
	"filename",
	"parent",
	"pos_x",
	"pos_y",
	"pos_z",
	"respawn_pos_x",
	"respawn_pos_y",
	"respawn_pos_z",
	"fall_rescue_pos_x",
	"fall_rescue_pos_y",
	"fall_rescue_pos_z",
	"rot_x",
	"rot_y",
	"rot_z",
	"scale_x",
	"scale_y",
	"scale_z"
]

func _unhandled_input(event: InputEvent) -> void:
	if $Level.get_children().size() == 0 and not debug_mode:
		if event.is_pressed():
			current_sequence.push_back(event.as_text())
			print(current_sequence)
			for i in range(current_sequence.size()):
				if current_sequence[i] != DEBUG_UNLOCK_SEQUENCE[i]:
					current_sequence.clear()
					break
				if i == (DEBUG_UNLOCK_SEQUENCE.size() - 1):
					debug_mode = true
	else:
		current_sequence.clear()

func quit_to_menu() -> void:
	print("quit in Main")
	$MainMenu.visible = true
	$MainMenu._ready()
	for child in $Level.get_children():
		$Level.remove_child(child)

func show_summary_screen(param_total_treasure: int, param_remaining_treasure: int,level: String,param_total_crests: int, param_remaining_crests: int):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$SummaryScreen.visible = true
	$SummaryScreen._ready()
	$SummaryScreen.level = level
	$SummaryScreen.set_completion(param_total_treasure,param_remaining_treasure,param_total_crests,param_remaining_crests)

func deferred_load(level: String) -> void:
	call_deferred("load_next_level",level)

func load_next_level(level: String) -> void:
	var remaining_treasure = total_treasure - $Level.get_child(0).calc_max_treasure()
	var remaining_crests = total_crests - $Level.get_child(0).calc_max_crests()
	$Level.remove_child($Level.get_child(0))
	if level == "End":
		load_level(level)
	else:
		show_summary_screen(total_treasure,remaining_treasure,level,total_crests,remaining_crests)

func load_level(level: String) -> void:
	if level == "End":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$MainMenu.visible = false
		$SummaryScreen.visible = false
		$EndScreen.visible = true
		$EndScreen._ready()
		$EndScreen.set_completion(treasure)
	else:
		var next_level = load(level)
		if $Level.get_children().size() > 0:
			$Level.remove_child($Level.get_child(0))
		$Level.add_child(next_level.instantiate())
		total_treasure = $Level.get_child(0).calc_max_treasure()
		total_crests = $Level.get_child(0).calc_max_crests()
		$MainMenu.visible = false
		$SummaryScreen.visible = false
		_init_level()

func save_treasure(value: int):
	treasure = value

func save_game() -> void:
	print("Saved game")
	var save_file = FileAccess.open("user://szakdolgozat.save",FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	save_file.store_line($Level.get_child(0).save())
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		
		save_file.store_line(json_string)
	
	save_file = FileAccess.open("user://szakdolgozatStates.save",FileAccess.WRITE)
	save_nodes = get_tree().get_nodes_in_group("PersistState")
	for node in save_nodes:
		if node.scene_file_path.is_empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		var node_data = node.call("save")
		var json_string = JSON.stringify(node_data)
		
		save_file.store_line(json_string)

func load_game() -> void:
	if not FileAccess.file_exists("user://szakdolgozat.save") or not FileAccess.file_exists("user://szakdolgozatStates.save"):
		return
	
	var save_file = FileAccess.open("user://szakdolgozat.save",FileAccess.READ)
	
	var level_file_path = save_file.get_line()
	var level = load(level_file_path).instantiate()
	$Level.add_child(level)
	total_treasure = $Level.get_child(0).calc_max_treasure()
	total_crests = $Level.get_child(0).calc_max_crests()
	
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.free()
	
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()
		
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		
		var node_data = json.data
		
		var new_object = load(node_data["filename"]).instantiate()
		get_node(node_data["parent"]).add_child(new_object)
		if new_object is Enemy:
			new_object.body.global_position = Vector3(node_data["pos_x"],node_data["pos_y"],node_data["pos_z"])
			new_object.body.global_rotation = Vector3(node_data["rot_x"],node_data["rot_y"],node_data["rot_z"])
			new_object.body.scale = Vector3(node_data["scale_x"],node_data["scale_y"],node_data["scale_z"])
		else:	
			new_object.global_position = Vector3(node_data["pos_x"],node_data["pos_y"],node_data["pos_z"])
			new_object.global_rotation = Vector3(node_data["rot_x"],node_data["rot_y"],node_data["rot_z"])
			new_object.scale = Vector3(node_data["scale_x"],node_data["scale_y"],node_data["scale_z"])
		if node_data.get("respawn_pos_x") != null:
			new_object.respawn_pos = Vector3(node_data["respawn_pos_x"],node_data["respawn_pos_y"],node_data["respawn_pos_z"])
			new_object.fall_rescue_pos = Vector3(node_data["fall_rescue_pos_x"],node_data["fall_rescue_pos_y"],node_data["fall_rescue_pos_z"])
			treasure = node_data["treasure"]
		
		for i in node_data.keys():
			if i in handled_keys:
				continue
			new_object.set(i,node_data[i])
			
	save_file = FileAccess.open("user://szakdolgozatStates.save",FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue
		var node_data = json.data
		var node = $Level.get_child(0).find_child(node_data["name"],true)
		for i in node_data.keys():
			if i == "name":
				continue
			if i == "activated":
				node.call("load_state",node_data[i])
				continue
			node.set(i,node_data[i])
		
	_init_level()
	$MainMenu.visible = false
	
func _init_level() -> void:
	if not $Level.get_child(0).is_connected("load_next_level",deferred_load):
		$Level.get_child(0).connect("load_next_level",deferred_load)
	if not $Level.get_child(0).is_connected("save_treasure",save_treasure):
		$Level.get_child(0).connect("save_treasure",save_treasure)
	if not $Level.get_child(0).is_connected("quit",quit_to_menu):
		$Level.get_child(0).connect("quit",quit_to_menu)
	for child in $Level.get_child(0).objects.get_children():
		if child is RespawnPlatform or child is BeginPlatform:
			if not child.is_connected("save_game",save_game):
				child.connect("save_game",save_game)
	$Level.get_child(0).init()
	$Level.get_child(0).player.treasure = treasure

func restart_game() -> void:
	treasure = 0
	total_crests = 0
	total_treasure = 0
	$EndScreen.visible = false
	$MainMenu.visible = true
	$MainMenu._ready()
