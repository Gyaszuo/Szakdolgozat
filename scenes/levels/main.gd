class_name Main
extends Node

var treasure: int

const handled_keys = [
	"filename",
	"parent",
	"node_name",
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

func quit_to_menu() -> void:
	$MainMenu.toggle(true)
	for child in $Level.get_children():
		$Level.remove_child(child)

func start_new_game() -> void:
	var test_level = load("res://scenes/test/test_level.tscn")
	$Level.add_child(test_level.instantiate())
	$MainMenu.toggle(false)
	$Level.get_child(0).init()

func load_next_level(level: String) -> void:
	var next_level = load(level)
	$Level.remove_child($Level.get_child(0))
	$Level.add_child(next_level.instantiate())
	$Level.get_child(0).init()
	$Level.get_child(0).player.treasure = treasure

func save_game() -> void:
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
		if new_object.has_method("init"):
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
		
	$MainMenu.toggle(false)
	$Level.get_child(0).init()
