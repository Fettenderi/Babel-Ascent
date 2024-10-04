class_name HarpCord extends Node3D

signal cord_touched

func _on_interactable_area_button_button_pressed(button: Variant) -> void:
	cord_touched.emit()
