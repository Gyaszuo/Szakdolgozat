class_name Spikes
extends Activatable

@export var preActivated: bool = false
@onready var spikes: MeshInstance3D = $floor_tile_big_spikes/floor_tile_big_spikes/spikes
@onready var damage: bool = true

func _ready() -> void:
	if preActivated:
		spikes.position.z = -0.02


func trigger() -> void:
	if not preActivated:
		activated = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(spikes,"position",Vector3(0,0,-0.02),0.25)
	else:
		activated = true
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(spikes,"position",Vector3(0,0,0),0.25)

func untrigger() -> void:
	if not preActivated:
		activated = false
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(spikes,"position",Vector3(0,0,0),0.25)
	else:
		activated = false
		var tween = create_tween()
		tween.set_ease(Tween.EASE_IN)
		tween.tween_property(spikes,"position",Vector3(0,0,-0.02),0.25)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Player:
		body.health -= 1
	else:
		body.get_parent().health -= 1

func _on_refresh_timer_timeout() -> void:
	$floor_tile_big_spikes/floor_tile_big_spikes/spikes/Area3D/CollisionShape3D.disabled = !damage
	damage = !damage
