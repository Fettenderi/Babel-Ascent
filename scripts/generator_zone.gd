@tool
extends Node3D

@export var object_scene : PackedScene:
	set(value):
		object_scene = value
		_update_editor_preview()

@onready var _entities : Node

var _object_preview : Node3D = null

func _ready() -> void:
	if Engine.is_editor_hint():
		_update_editor_preview()
	else:
		_entities = Node.new()
		_entities.name = "Entities"
		add_child(_entities, true)
		
		_spawn_object()

func _spawn_object():
	if object_scene:
		var object_instance : Node3D = object_scene.instantiate()
		
		_entities.add_child(object_instance, true)
		
		%SnapZone.pick_up_object(object_instance)

func _update_editor_preview():
	if object_scene:
		if _object_preview:
			remove_child(_object_preview)
			_object_preview.queue_free()
			_object_preview = null
		
		_object_preview = object_scene.instantiate()
		
		add_child(_object_preview, true)


func _on_snap_zone_has_dropped() -> void:
	_spawn_object()
