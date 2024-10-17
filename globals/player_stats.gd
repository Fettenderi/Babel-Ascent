extends Node

const STARTING_HEALTH := 10

signal health_changed(value)
signal died

signal light_changed(value)

@export var health : float:
	set(value):
		health = value
		_current_health = value

@onready var _current_health :=  health:
	set(value):
		_current_health = value
		health_changed.emit(_current_health)
		
		if value <= 0:
			died.emit()

@onready var unlocked_items : Dictionary = {
	&"Hammer" : false,
	&"Crossbow" : false,
	&"Harp" : false,
	&"StunningHammer" : false,
	&"Cannon" : false,
	&"Bricks" : true
}

@export var tower_level : int = 0:
	set(value):
		tower_level = value
		health = STARTING_HEALTH + 5 * tower_level

@export var _current_light := 0:
	set(value):
		_current_light = min(value, 30)
		light_changed.emit(_current_light)
