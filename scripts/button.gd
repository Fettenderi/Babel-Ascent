extends StaticBody3D

signal button_pressed

func _on_interactable_area_button_button_pressed(_button: Variant) -> void:
	button_pressed.emit()
