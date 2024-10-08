extends Node

signal health_changed(value)
signal died

signal light_changed(value)

@export var health : int:
	set(value):
		health = value
		_current_health = value

@onready var _current_health :=  health:
	set(value):
		_current_health = value
		health_changed.emit(_current_health)
		
		if value <= 0:
			died.emit()

@onready var _unlocked_items : Array[bool] = []
@onready var _tower_level : int = 0

var _current_light := 0:
	set(value):
		_current_light = value
		light_changed.emit(_current_light)

func _ready() -> void:
	for _i in range(5):
		_unlocked_items.append(false)
