@tool
extends MovementBehaviour

@export var switching_time := 1.0:
	set(value):
		switching_time = value
		_setup_preview()

@onready var _patterns : Array[MovementBehaviour]
@onready var _preview_update_timer : Timer
@onready var _switch_timer : Timer

var _index := -1
var _current_pattern : MovementBehaviour

func get_direction(time := -1.0) -> Vector3:
	if _patterns.size() <= 0: return Vector3.ZERO
	if time < 0.0: return _current_pattern.get_direction(time)
	
	var _preview_index : int = (int(floor(time / switching_time) + 1)) % _patterns.size()
	return _patterns[_preview_index].get_direction(time)

func _ready() -> void:
	super()
	_setup_patterns()
	
	if not Engine.is_editor_hint():
		_switch_timer = Timer.new()
		
		_switch_timer.autostart = false
		_switch_timer.one_shot = true
		_switch_timer.timeout.connect(_on_switch_timer_timeout)
		call_deferred("add_child", _switch_timer, true)
		
		_switch_timer.start(switching_time)
		
		_update_current_pattern()
	else:
		_preview_update_timer = Timer.new()
		
		_preview_update_timer.autostart = true
		_preview_update_timer.one_shot = false
		_preview_update_timer.timeout.connect(_setup_patterns)
		call_deferred("add_child", _preview_update_timer, true)
		
		_preview_update_timer.start(0.5)

func _on_switch_timer_timeout() -> void:
	_switch_timer.start(switching_time)
	
	_update_current_pattern()

func _update_current_pattern() -> void:
	_index = (_index + 1) % _patterns.size()
	_current_pattern = _patterns[_index]

func _setup_patterns():
	if _patterns:
		_patterns.clear()
	else:
		_patterns = []
	
	for _child in get_children():
		if _child is MovementBehaviour:
			_patterns.append(_child)
