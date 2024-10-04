@tool
extends Node3D

@onready var _cords : Array[Node3D]

var _cords_count := 0
var _last_touched := -1
var _streak := 0

func throw():
	pass

func _ready() -> void:
	for _child: HarpCord in get_children():
		_child.cord_touched.connect(_cord_touched.bind(_cords_count))
		_child.scale.y = 1.5 - 0.05 * _cords_count
		_child.scale.z = 1.5 - 0.05 * _cords_count
		_cords.append(_child)
		_cords_count += 1

func _cord_touched(_id: int) -> void:
	if _id <= _last_touched:
		_last_touched = _id
		_streak = 0
		return
	
	_last_touched += 1
	_streak += 1
	
	@warning_ignore("integer_division")
	
	if _streak >= _cords_count * 0.7:
		_last_touched = -1
		_streak = 0
		throw()
