extends Area3D

@export var stunn_radius := 5.0
@export var stunn_activation_cooldown := 10.0

@onready var _stunning_indicator_mesh : SphereMesh = %StunningIndicatorMesh.mesh
@onready var _stunning_collision : SphereShape3D = %CollisionShape3D.shape

@onready var _stunn_activation_timer : Timer

@onready var _stunned_scene := preload("res://objects/components/stunned.tscn")

var _is_active := true

func _ready() -> void:
	%StunningEvent.preload_event = true
	_stunn_activation_timer = Timer.new()
	
	_stunn_activation_timer.autostart = false
	_stunn_activation_timer.one_shot = true
	_stunn_activation_timer.wait_time = stunn_activation_cooldown
	_stunn_activation_timer.timeout.connect(_set_active)

func _on_hurt_box_hurtbox_entered(_object: Variant) -> void:
	if _is_active:
		var tween := create_tween()
		_is_active = false
		_stunn_activation_timer.start()
		
		%StunningEvent.play()
		
		tween.set_parallel(true)
		tween.tween_property(_stunning_collision, "radius", stunn_radius, 0.5)
		tween.tween_property(_stunning_indicator_mesh, "radius", stunn_radius, 0.5)
		tween.tween_property(_stunning_indicator_mesh, "height", stunn_radius * 2, 0.5)

		tween.tween_property(_stunning_collision, "radius", 0.001, 0.5).set_delay(0.5)
		tween.tween_property(_stunning_indicator_mesh, "radius", 0.001, 0.5).set_delay(0.5)
		tween.tween_property(_stunning_indicator_mesh, "height", 0.002, 0.5).set_delay(0.5)


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(&"Enemy"):
		area.get_parent().add_child(_stunned_scene.instantiate(), true)

func _set_active():
	_is_active = true
