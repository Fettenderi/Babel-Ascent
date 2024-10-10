extends Node3D

const STARTING_TOWER_Y := -0.29
const TOWER_OFFSET_Y := 3.13

const STARTING_TOWER_SCALE := 0.8
const TOWER_OFFSET_SCALE := 0.3

signal tower_built

@onready var _objects_with_desk := preload("res://objects/interactables/objects_with_desk.tscn")
@onready var _objects_with_ground := preload("res://objects/interactables/objects.tscn")
@onready var _tower_module := preload("res://objects/static/tower_module.tscn")

@onready var _xr_origin : XROrigin3D

func _ready() -> void:
	_xr_origin = XRTools.find_xr_child(get_parent(), "*", "XROrigin3D")
	
	_spawn_tower()

func _spawn_tower():
	var _module_instance : Node3D
	
	if PlayerStats.tower_level == 0:
		_module_instance = _objects_with_ground.instantiate()
		add_child(_module_instance, true)
		
		tower_built.emit()
		return
	elif PlayerStats.tower_level == 1:
		_module_instance = _objects_with_desk.instantiate()
		add_child(_module_instance, true)
		
		tower_built.emit()
		return
	
	_module_instance = _objects_with_desk.instantiate()
	add_child(_module_instance, true)
	
	var _cumulative_offset := 0.0
	
	for _i in range(PlayerStats.tower_level - 1):
		_module_instance = _tower_module.instantiate()
		add_child(_module_instance, true)
		
		_module_instance.scale.x = STARTING_TOWER_SCALE + TOWER_OFFSET_SCALE * _i
		_module_instance.scale.z = STARTING_TOWER_SCALE + TOWER_OFFSET_SCALE * _i
		_module_instance.position.y = STARTING_TOWER_Y - TOWER_OFFSET_Y * _i
		_cumulative_offset = TOWER_OFFSET_Y * (_i + 1)
	
	position.y = _cumulative_offset
	_xr_origin.position.y = _cumulative_offset
	
	tower_built.emit()
