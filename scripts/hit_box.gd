class_name HitBox extends Area3D

signal health_changed(new_heath: float)
signal died

@export var health := 1.0

@export var damaged_by : StringName

@onready var _current_health := health:
	set(value):
		_current_health = value
		health_changed.emit(_current_health)
		
		if _current_health <= 0.0:
			died.emit()

func _on_area_entered(area: Area3D) -> void:
	if area is HurtBox and area.is_in_group(damaged_by):
		_current_health -= area.damage
