extends Node

const STARTING_HEALTH := 1

signal health_changed(value)
signal died

signal light_changed(value)

@onready var health : float:
	set(value):
		health = value
		_current_health = value

@onready var _current_health :=  health:
	set(value):
		_current_health = value
		health_changed.emit(_current_health)
		
		if value <= 0:
			died.emit()

@export var debug_mode := false

@onready var unlocked_items : Dictionary = {
	&"Hammer" : true if debug_mode else false,
	&"Crossbow" : true if debug_mode else false,
	&"Harp" : true if debug_mode else false,
	&"StunningHammer" : true if debug_mode else false,
	&"Cannon" : true if debug_mode else false,
	&"Bricks" : true
}

@onready var tower_level : int = 2 if debug_mode else 0:
	set(value):
		tower_level = value
		health = STARTING_HEALTH + tower_level

@onready var _current_light := 0:
	set(value):
		_current_light = min(value, 30)
		light_changed.emit(_current_light)
