class_name HurtBox extends Area3D

@export var damage := 1.0

signal hurtbox_entered(object)

func _on_area_entered(area: Area3D) -> void:
	if area is HitBox and is_in_group(area.damaged_by):
		hurtbox_entered.emit(area)
