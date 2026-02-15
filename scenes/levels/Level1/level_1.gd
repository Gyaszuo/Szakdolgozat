class_name Level1
extends Level

func open_door():
	print("open_door")
	$Objects/Trigger.activated = false
	$Objects/Trigger.call_deferred("enable")
	$Objects/Trigger.deactivate()

func init_gauntlet():
	print("init_gauntlet")
	$Objects/EnemyKillSwitch.enabled = true
