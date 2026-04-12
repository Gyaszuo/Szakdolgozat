class_name Fireball
extends Area3D

var direction: Vector3
var speed: float

func _ready() -> void:
	speed = randf_range(5,10)

func _process(delta: float) -> void:
	position += Vector3(direction.x,direction.y,direction.z) * speed * delta

func _on_life_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	print("entered")
	if "hit" in body:
		body.hit()
	if "hit" in body.get_parent():
		body.get_parent().hit()
	queue_free()
