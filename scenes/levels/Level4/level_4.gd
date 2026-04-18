class_name Level4
extends Level

@onready var boss: Boss = $Entities/Boss
@onready var boss_pos: Vector3 = boss.body.global_position
@onready var boss_rot: Vector3 = Vector3(0,deg_to_rad(-180.0),0)

func activate_boss():
	$Objects/Door.untrigger()	
	boss.activate()
	$Objects/Door2.trigger()
	boss.toggle_boss_healthbar(true)
	$HeartTimer.start()
	player.boss = boss

func restart_boss():
	$Objects/Door2.untrigger()
	$Objects/Trigger.activated = false
	$Objects/Trigger.call_deferred("enable")
	for child in entities.get_children():
		if child is Enemy and child is not Boss:
			child.queue_free()
	boss.body.global_position = boss_pos
	boss.global_rotation = boss_rot
	boss.reset()
	boss.toggle_boss_healthbar(false)
	$HeartTimer.stop()

func end_boss():
	$Objects/Door.trigger()
	boss.toggle_boss_healthbar(false)

func spawn_heart():
	if player.health == 6 or collectibles.get_children().size() > 0:
		return
	var pos = randi_range(1,4)
	var heart_scene = load("res://scenes/objects/collectibles/Heart.tscn")
	var heart = heart_scene.instantiate()
	collectibles.add_child(heart)
	heart.global_position = get_node("Objects/HeartSummon"+String.num_int64(pos)).global_position

func raise_skeletons(type: int):
	if type == 3:
		var grunt_scene = load("res://scenes/entities/enemies/Grunt.tscn")
		for i in range(2):
			var grunt = grunt_scene.instantiate()
			entities.add_child(grunt)
			grunt.global_position = get_node("Objects/EnemySummon"+String.num_int64(i+1)).global_position
			grunt.connect("death",boss.raise_start)
			grunt.player = player
			grunt.global_rotation = boss_rot
			grunt.init()
			grunt.boss_fight = true
	elif type == 2:
		var warrior_scene = load("res://scenes/entities/enemies/Warrior.tscn")
		for i in range(2):
			var warrior = warrior_scene.instantiate()
			entities.add_child(warrior)
			warrior.global_position = get_node("Objects/EnemySummon"+String.num_int64(i+1)).global_position
			warrior.connect("death",boss.raise_start)
			warrior.player = player
			warrior.global_rotation = boss_rot
			warrior.init()
			warrior.boss_fight = true
	elif type == 1:
		var rogue_scene = load("res://scenes/entities/enemies/Rogue.tscn")
		for i in range(2):
			var rogue = rogue_scene.instantiate()
			entities.add_child(rogue)
			rogue.global_position = get_node("Objects/EnemySummon"+String.num_int64(i+1)).global_position
			rogue.connect("death",boss.raise_start)
			rogue.player = player
			rogue.global_rotation = boss_rot
			rogue.init()
			rogue.boss_fight = true
