class_name Level2
extends Level

@onready var gauntlet_entrance: Door = $Objects/Door
@onready var gauntlet_exit: Door = $Objects/Door2
@onready var enemy_barrier: EnemyBarrier = $Objects/EnemyBarrier6
const BOX_1_POSITION = Vector3(-9.685,7.538,79.9)
const BOX_2_POSITION = Vector3(-9.685,7.538,86.2)
const BOX_3_POSITION = Vector3(-9.685,7.538,92.2)

func speed_up_platforms():
	$Objects/Path3D/PathFollow3D/MovingPlatform.speed = 8.0
	$Objects/Path3D2/PathFollow3D/MovingPlatform.speed = 8.0

func end_gauntlet():
	restart_gauntlet()
	$Objects/GauntletStartTrigger.one_time = true
	$Objects/GauntletStartTrigger.activated = true

func start_gauntlet():
	gauntlet_entrance.trigger()
	gauntlet_exit.trigger()
	$Objects/EnemyKillSwitch.enabled = true
	enemy_barrier.trigger()

func restart_gauntlet():
	gauntlet_entrance.untrigger()
	gauntlet_exit.untrigger()
	$Objects/EnemyKillSwitch.enabled = false
	enemy_barrier.untrigger()

func reset_boxes():
	if $Objects/Switch.activated:
		$Objects/Switch._on_area_3d_area_entered(null)
	if $Objects/Switch2.activated:
		$Objects/Switch2._on_area_3d_area_entered(null)
	if $Objects/Switch3.activated:
		$Objects/Switch3._on_area_3d_area_entered(null)
	await get_tree().create_timer(1.0).timeout
	var box1 = objects.get_node("Box3")
	var box2 = objects.get_node("Box4")
	var box3 = objects.get_node("Box5")
	box1.global_position = BOX_1_POSITION
	box2.global_position = BOX_2_POSITION
	box3.global_position = BOX_3_POSITION
	$Objects/Switch4._on_area_3d_area_entered(null)
