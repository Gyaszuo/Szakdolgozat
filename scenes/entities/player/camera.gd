class_name Camera
extends SpringArm3D

@export var horizontal_acc: float = 3.0
@export var vertical_acc: float = 2.0
@export var max_limit_x: float = 0
@export var min_limit_x: float = -1
@export var mouse_acceleration: float = 0.005

var smooth_rotation: Vector3

func _process(delta: float) -> void:
	var joy_dir: Vector2 = Input.get_vector("pan_left","pan_right","pan_up","pan_down")
	rotate_from_vector(joy_dir * delta * Vector2(horizontal_acc,vertical_acc))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_from_vector(event.relative * mouse_acceleration)
		

func rotate_from_vector(vector: Vector2) -> void:
	if vector.length() == 0: return
	rotation.y = wrapf(rotation.y - vector.x,-PI,PI)
	rotation.x -= vector.y
	rotation.x = clampf(rotation.x,min_limit_x,max_limit_x)
