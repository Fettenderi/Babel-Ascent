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

@export var unlocked_items : Dictionary = {
	&"Hammer" : false,
	&"Crossbow" : false,
	&"Harp" : false,
	&"StunningHammer" : false,
	&"Cannon" : false
}

@onready var tower_level : int = 0

@export var _current_light := 0:
	set(value):
		_current_light = value
		light_changed.emit(_current_light)
