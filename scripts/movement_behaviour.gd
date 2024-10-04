@tool
class_name MovementBehaviour extends Node

@export var show_tooltip := false:
	set(value):
		show_tooltip = value
		_setup_preview()

@export var tooltip_lenght := 10.0:
	set(value):
		tooltip_lenght = value
		_setup_preview()

@export var tooltip_duration := 2.0:
	set(value):
		tooltip_duration = value
		_setup_preview()

@onready var _tooltip_preview_speed := 5.0:
	set(value):
		_tooltip_preview_speed = value
		_setup_preview()
		_update_preview_speed(value)

@onready var _sphere_material : StandardMaterial3D = preload("res://assets/materials/sphere_preview.tres")
@onready var _dot_material : StandardMaterial3D = preload("res://assets/materials/dots_preview.tres")

@onready var _parent : Node = get_parent()

var _preview_sphere : CSGSphere3D
var _preview_path : Path3D
var _preview_path_follower : PathFollow3D
var _preview_curve : Curve3D
var _dots : Array[CSGSphere3D]
var _progress := 0.0

func get_direction(_time := -1.0) -> Vector3:
	return Vector3.ZERO

func _ready() -> void:
	show_tooltip = false

func _process(delta: float) -> void:
	_update_preview(delta)

func _setup_preview() -> void:
	if _parent is MovementBehaviour:
		_parent._setup_preview()
	elif _parent is AbstractEnemy:
		_parent._movement_pattern = self
	
	if not Engine.is_editor_hint(): return
	
	_progress = 0.0
	
	if _preview_sphere:
		_preview_path_follower.call_deferred("remove_child", _preview_sphere)
		_preview_sphere.queue_free()
		_preview_sphere = null
	
	if _preview_path_follower:
		_preview_path.call_deferred("remove_child", _preview_path_follower)
		_preview_path_follower.queue_free()
		_preview_path_follower = null
	
	if _preview_path:
		call_deferred("remove_child", _preview_path)
		_preview_path.queue_free()
		_preview_path = null
	
	if _preview_curve:
		_preview_curve.clear_points()
	
	if _dots:
		for _dot: CSGSphere3D in _dots:
			call_deferred("remove_child", _dot)
			_dot.queue_free()
		_dots.clear()

	if not show_tooltip: return
	
	_preview_path = Path3D.new()
	call_deferred("add_child", _preview_path, true)

	_preview_path_follower = PathFollow3D.new()
	_preview_path.call_deferred("add_child", _preview_path_follower, true)
	
	_preview_sphere = CSGSphere3D.new()
	_preview_sphere.material = _sphere_material
	_preview_sphere.radius = 0.2
	_preview_sphere.radial_segments = 24
	_preview_sphere.rings = 12
	_preview_path_follower.call_deferred("add_child", _preview_sphere, true)
	
	if not _preview_curve:
		_preview_curve = Curve3D.new()
	_preview_path.curve = _preview_curve
	
	if not _dots:
		_dots = []
	
	var _position : Vector3 = Vector3.ZERO
	
	for _point in range(0, tooltip_lenght * 10 + 1, 1):
		_position += get_direction(_point / 10.0) * _tooltip_preview_speed * 0.1# * _point / 10.0
		
		_preview_curve.add_point(_position)
		_add_dot(_position)
	

func _add_dot(position: Vector3) -> void:
	var _dot := CSGSphere3D.new()
	_dot.material = _dot_material
	_dot.radius = 0.1
	_dot.radial_segments = 6
	_dot.rings = 3
	_dot.position = position
	call_deferred("add_child", _dot, true)
	
	_dots.append(_dot)

func _update_preview(delta: float) -> void:
	if not Engine.is_editor_hint(): return
	
	if not show_tooltip: return
	
	_progress += delta
	
	if _progress >= tooltip_duration:
		_progress = 0.0
	
	_preview_path_follower.progress_ratio = _progress / tooltip_duration

func _update_preview_speed(value: float) -> void:
	var _c := get_child_count()
	if _c <= 0: return
	
	var _i := 0
	var _s : Node
	while _i < _c:
		_s = get_child(_i)
		if _s is MovementBehaviour:
			_s._tooltip_preview_speed = value
		_i += 1
