class_name HarpCord extends Node3D

signal cord_touched(pos)

var _on_cooldown := false

func _on_interactable_area_button_button_pressed(_button: Variant, pos: Vector3) -> void:
	if not _on_cooldown:
		_on_cooldown = true
		%TouchCooldown.start()
		cord_touched.emit(pos)


func _on_touch_cooldown_timeout() -> void:
	_on_cooldown = false
