extends Node3D

@export var entities : Node3D

@export var fire_force := 100.0
@export var cooldown_time := 0.5
@export var delay_time := 1.5
@export var cannon_ball_scene : PackedScene

var _ammo_cannon_ball : XRToolsPickable
var _on_cooldown := false
var _is_buffered := false

func _on_interactable_area_button_button_pressed(_button: Variant) -> void:
	if not _has_ammo():
		return
	
	if _on_cooldown:
		_is_buffered = true
		return
	
	_on_cooldown = true
	
	_remove_ammo()
	
	%FireCooldown.start(cooldown_time)

func _fire_cannon():
	var cannon_ball_instance : CannonBallPickable = cannon_ball_scene.instantiate()
	
	entities.add_child(cannon_ball_instance, true)
	
	cannon_ball_instance.throw((%FireHole.global_position - %BallDirection.global_position).normalized() * fire_force, %FireHole.global_position)
	
	if _is_buffered:
		_is_buffered = false
		_remove_ammo()
		
		%FireCooldown.start(cooldown_time / 2)
	else:
		%FireDelay.start(delay_time)

func _has_ammo() -> bool:
	return is_instance_valid(%SnapZone4.picked_up_object) or is_instance_valid(%SnapZone3.picked_up_object) or is_instance_valid(%SnapZone2.picked_up_object) or is_instance_valid(%SnapZone1.picked_up_object)

func _remove_ammo():
	if is_instance_valid(%SnapZone4.picked_up_object):
		_ammo_cannon_ball = %SnapZone4.picked_up_object
		%SnapZone4.drop_object()
	elif is_instance_valid(%SnapZone3.picked_up_object):
		_ammo_cannon_ball = %SnapZone3.picked_up_object
		%SnapZone3.drop_object()
	elif is_instance_valid(%SnapZone2.picked_up_object):
		_ammo_cannon_ball = %SnapZone2.picked_up_object
		%SnapZone2.drop_object()
	elif is_instance_valid(%SnapZone1.picked_up_object):
		_ammo_cannon_ball = %SnapZone1.picked_up_object
		%SnapZone1.drop_object()
	else:
		return
	
	_ammo_cannon_ball.queue_free()


func _on_fire_cooldown_timeout() -> void:
	_fire_cannon()

func _on_fire_delay_timeout() -> void:
	_on_cooldown = false
