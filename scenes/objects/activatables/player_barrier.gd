class_name PlayerBarrier
extends Activatable

@export var preActivated: bool = false
@export var invisible: bool = false

func _ready() -> void:
	if preActivated:
		$StaticBody3D/CollisionShape3D.disabled = true
		$Area3D/CollisionShape3D.disabled = true
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.25,0,1.0)
	if invisible:
		fade(0)

func trigger() -> void:
	if not preActivated:
		activated = true
		$StaticBody3D/CollisionShape3D.disabled = true
		$Area3D/CollisionShape3D.disabled = true
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.25,0.0,1.0)
	else:
		activated = true
		$StaticBody3D/CollisionShape3D.disabled = false
		$Area3D/CollisionShape3D.disabled = false
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.0,0.25,1.0)

func untrigger() -> void:
	if not preActivated:
		activated = false
		$StaticBody3D/CollisionShape3D.disabled = false
		$Area3D/CollisionShape3D.disabled = false
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.0,0.25,1.0)
	else:
		activated = false
		$StaticBody3D/CollisionShape3D.disabled = true
		$Area3D/CollisionShape3D.disabled = true
		if not invisible:
			var tween = create_tween()
			tween.tween_method(self.fade,0.25,0.0,1.0)

func fade(value: float) -> void:
	$Mesh.mesh.material.albedo_color.a = value

func _on_area_3d_body_entered(body: Node3D) -> void:
	if is_instance_of(body,Player) and body.is_hooking:
		body.set_move_state("Jump_Idle")
		body.squash_and_stretch_component.do_squash_and_stretch(1.2,0.15)
		body.velocity.y = body.djump_impulse /2
		body.is_hooking = false
		body.barrier_blocked = true
		body.fall_speed = 0.5
