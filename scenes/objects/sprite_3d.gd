extends Sprite3D

var dir: bool = false
const FLOAT_SPEED: float = 0.005
const FLOAT_CAP: float = 0.25

func _physics_process(_delta: float) -> void:
	if dir:
		$".".position.y -= FLOAT_SPEED
	else:
		$".".position.y += FLOAT_SPEED
	if $".".position.y <= -(FLOAT_CAP) or $".".position.y >= FLOAT_CAP:
		dir = !dir
