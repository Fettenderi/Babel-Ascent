@tool
class_name AbstractEnemy extends CharacterBody3D

signal died

@export var speed := 5.0:
	set(value):
		speed = value
		
		if not Engine.is_editor_hint() or not _movement_pattern: return
		_movement_pattern._tooltip_preview_speed = value

@export var light_released := 1

@export var _light_scene : PackedScene

var _movement_pattern : MovementBehaviour

var _player : Camera3D

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _player:
		look_at_from_position(global_position, _player.global_position, Vector3.UP, true)
	
	velocity = transform.basis * _movement_pattern.get_direction().normalized() * speed * delta
	
	move_and_collide(velocity)

func _on_hit_box_died() -> void:
	var _light_instance : XRToolsPickable
	
	for _i in range(light_released):
		_light_instance = _light_scene.instantiate()
		
		_light_instance.global_position = global_position + Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1) * 0.5
		
		get_parent().add_child(_light_instance, true)
	
	died.emit()
	
	queue_free()


func _on_hit_box_health_changed(_new_heath: float) -> void:
	var tween := create_tween()
	
	tween.tween_property(%DamageIndicator, "visible", true, 0.5)
	tween.tween_property(%DamageIndicator, "visible", false, 0.5)


func _on_tree_entered() -> void:
	if Engine.is_editor_hint(): return
	
	if _player:
		look_at_from_position(global_position, _player.global_position, Vector3.UP, true)
