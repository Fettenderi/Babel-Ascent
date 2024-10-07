@tool
class_name CannonBallPickable extends XRToolsPickable

@export var despawn_time := 10.0

@onready var _despawn_timer : Timer

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	_despawn_timer = Timer.new()
	_despawn_timer.autostart = false
	_despawn_timer.one_shot = true
	_despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	
	add_child(_despawn_timer, true)

func throw(force: Vector3, from: Vector3) -> void:
	global_position = from
	add_constant_force(force, Vector3.ZERO)
	_despawn_timer.start(despawn_time)
	enabled = false


func _on_despawn_timer_timeout() -> void:
	queue_free()
