class_name PlayerStats extends Node

@export var health : int:
	set(value):
		health = value
		_current_health = value

@onready var _current_health :=  health:
	set(value):
		_current_health = value
		health_changhed.emit(_current_health)
		
		if value <= 0:
			died.emit()

signal health_changhed(value)
signal died
