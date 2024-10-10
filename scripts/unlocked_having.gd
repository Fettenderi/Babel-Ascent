@tool
class_name UnlockedHaving extends Node3D

@export var unlocking_item : StringName
@export var locking_item : StringName

@export var item_scene : PackedScene:
	set(value):
		item_scene = value
		_update_editor_preview()

var _item_preview : Node3D = null

func _enter_tree() -> void:
	if Engine.is_editor_hint():
		_update_editor_preview()
		return


func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	var _enabled : bool = PlayerStats.unlocked_items[unlocking_item] and (not locking_item or not PlayerStats.unlocked_items[locking_item])
	
	if not _enabled:
		queue_free()
		return
	
	var _item_istance : Node3D = item_scene.instantiate()
	
	get_parent().call_deferred("add_child", _item_istance, true)
	
	_item_istance.position = position
	_item_istance.rotation = rotation
	
	await _item_istance.tree_entered
	
	queue_free()

func _update_editor_preview():
	if item_scene:
		if _item_preview:
			remove_child(_item_preview)
			_item_preview.queue_free()
			_item_preview = null
		
		_item_preview = item_scene.instantiate()
		
		add_child(_item_preview, true)
