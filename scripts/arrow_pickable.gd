@tool
class_name ArrowPickable extends XRToolsPickable

@export var despawn_time := 10.0

@onready var _despawn_timer : Timer

func _ready() -> void:
	super()
	
	if Engine.is_editor_hint(): return
	_despawn_timer = Timer.new()
	_despawn_timer.autostart = false
	_despawn_timer.one_shot = true
	_despawn_timer.timeout.connect(_on_despawn_timer_timeout)
	
	call_deferred("add_child", _despawn_timer, true)

func throw(force: float) -> void:
	add_constant_force(-force * transform.basis.z, Vector3.ZERO)
	_despawn_timer.start(despawn_time)
	enabled = false


func _on_despawn_timer_timeout() -> void:
	queue_free()
