class_name UnlockedHaving extends Node3D

@export var unlocking_item : StringName
@export var locking_item : StringName

@export var item_scene : PackedScene

func _ready() -> void:
	var _enabled : bool = PlayerStats.unlocked_items[unlocking_item] and (not locking_item or not PlayerStats.unlocked_items[locking_item])
	
	if not _enabled:
		queue_free()
		return
	
	var _item_istance : Node3D = item_scene.instantiate()
	
	get_parent().call_deferred("add_child", _item_istance, true)
	
	_item_istance.global_rotation = global_rotation
	_item_istance.global_position = global_position
	
	await _item_istance.tree_entered
	
	queue_free()
