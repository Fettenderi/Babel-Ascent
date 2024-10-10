@tool
class_name AbstractEnemy extends CharacterBody3D

signal died

@export var speed := 5.0:
	set(value):
		speed = value
		
		if not Engine.is_editor_hint() or not _movement_pattern: return
		_movement_pattern._tooltip_preview_speed = value

@export var light_released := 1

@export var damage_indicator_radius := 1.0

@export var _light_scene : PackedScene

@onready var _damage_indicator_mesh : SphereMesh = %DamageIndicator.mesh

@onready var _player : XRCamera3D
@onready var _ambience_timer : Timer

var _movement_pattern : MovementBehaviour

func _ready() -> void:
	_ambience_timer = Timer.new()
	_ambience_timer.autostart = true
	_ambience_timer.one_shot = false
	_ambience_timer.wait_time = (randf() * 5) + 5
	_ambience_timer.timeout.connect(_play_ambience)
	
	%DeathEvent.preload_event = true
	%DamageEvent.preload_event = true
	%AmbienceEvent.preload_event = true
	
	%DeathEvent.stopped.connect(_died)

func _play_ambience():
	_ambience_timer.wait_time = (randf() * 5) + 5
	%AmbienceEvent.play()
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	if _player:
		look_at_from_position(global_position, _player.global_position, Vector3.UP, true)
	
	velocity = transform.basis * _movement_pattern.get_direction().normalized() * speed * delta
	
	move_and_collide(velocity)

func _on_hit_box_died() -> void:
	var _light_instance : Light
	
	for _i in range(light_released):
		_light_instance = _light_scene.instantiate()
		
		_light_instance.global_position = global_position + Vector3(randf() * 2 - 1, randf() * 2 - 1, randf() * 2 - 1) * 0.5
		_light_instance.needs_despawning = true
		
		get_parent().add_child(_light_instance, true)
	
	%DeathEvent.play()

func _died():
	died.emit()
	queue_free()

func _on_hit_box_health_changed(_new_heath: float) -> void:
	var tween := create_tween()
	
	tween.set_parallel(true)
	tween.tween_property(_damage_indicator_mesh, "radius", damage_indicator_radius, 0.5)
	tween.tween_property(_damage_indicator_mesh, "height", damage_indicator_radius * 2, 0.5)

	tween.tween_property(_damage_indicator_mesh, "radius", 0.001, 0.5).set_delay(0.5)
	tween.tween_property(_damage_indicator_mesh, "height", 0.002, 0.5).set_delay(0.5)
	
	%DamageEvent.play()

func _on_tree_entered() -> void:
	if Engine.is_editor_hint(): return
	
	if _player:
		look_at_from_position(global_position, _player.global_position, Vector3.UP, true)
