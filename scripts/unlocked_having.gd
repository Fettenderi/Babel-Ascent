class_name UnlockedHaving extends Node

@export var unlocking_item : StringName
@export var locking_item : StringName

func _ready() -> void:
	var _enabled : bool = PlayerStats.unlocked_items[unlocking_item] and (not locking_item or not PlayerStats.unlocked_items[locking_item])
	
	get_parent().set_process(_enabled)
	get_parent().set_deferred("visible", _enabled)
