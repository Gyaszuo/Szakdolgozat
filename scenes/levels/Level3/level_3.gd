class_name Level3
extends Level

const BOX_1_POSITION = Vector3(-13.0,36.828,-7.4)
const BOX_2_POSITION = Vector3(-13.0,36.828,-8.1)
const BOX_3_POSITION = Vector3(-7.1,44.428,6.1)

func _physics_process(_delta: float) -> void:
	spin_platforms()

func rotate_platform() -> void:
	var tween = create_tween()
	tween.tween_property($Objects/RotatingPlatform,"rotation",Vector3(0,deg_to_rad(90),0),10)

func spin_platforms() -> void:
	$Objects/SpinningPlatfrom.global_rotation.y += 0.01
	$Objects/SpinningPlatfrom2.global_rotation.y += 0.01
	$Objects/SpinningPlatfrom3.global_rotation.y += 0.01
	$Objects/SpinningPlatfrom4.global_rotation.y += 0.01

func reset_boxes() -> void:
	var box1 = objects.get_node("Box3")
	var box2 = objects.get_node("Box4")
	var box3 = objects.get_node("Box5")
	box1.global_position = BOX_1_POSITION
	box2.global_position = BOX_2_POSITION
	box3.global_position = BOX_3_POSITION
	$Objects/Switch3._on_area_3d_area_entered(null)
