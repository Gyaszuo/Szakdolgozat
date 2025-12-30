class_name Fireball
extends Area3D

var direction: Vector2
const speed: float = 5.0

func _process(delta: float) -> void:
	position += Vector3(direction.x,0,direction.y) * speed * delta

func _on_life_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body: Node3D) -> void:
	if "hit" in body:
		body.hit()
	if "hit" in body.get_parent():
		body.get_parent().hit()
	queue_free()
