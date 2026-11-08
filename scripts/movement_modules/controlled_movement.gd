@tool
extends MovementBehaviour

@export var controller : Node

@onready var _patterns : Array[MovementBehaviour]
@onready var _preview_update_timer : Timer

var _index := -1
var _current_pattern : MovementBehaviour
var _preview_switching_time := 2.0

func get_direction(time := -1.0) -> Vector3:
	if _patterns.size() <= 0: return Vector3.ZERO
	if time < 0.0: return _current_pattern.get_direction(time)
	
	var _preview_index : int = (int(floor(time / _preview_switching_time) + 1)) % _patterns.size()
	return _patterns[_preview_index].get_direction(time)

func _ready() -> void:
	super()
	_setup_patterns()
	
	if not Engine.is_editor_hint():
		if controller:
			controller.update.connect(_update_current_pattern)
		_update_current_pattern()
	else:
		_preview_update_timer = Timer.new()
		
		_preview_update_timer.autostart = true
		_preview_update_timer.one_shot = false
		_preview_update_timer.timeout.connect(_setup_patterns)
		call_deferred("add_child", _preview_update_timer, true)
		
		_preview_update_timer.start(0.5)

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
