class_name TimerSwitch
extends Activator

var activated: bool = false
@export var offset: float = 0
@export var wait_time: float = 5.0

func _ready() -> void:
	$RepeatTimer.wait_time = wait_time
	if offset == 0:
		$RepeatTimer.start()
	else:
		$OffsetTimer.wait_time = offset
		$OffsetTimer.start()

func _on_timer_timeout() -> void:
	if activated:
		deactivate()
	else:
		activate()
	activated = !activated

func _on_offset_timer_timeout() -> void:
	$RepeatTimer.start()
