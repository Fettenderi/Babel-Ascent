extends Node3D

func _on_previous_button_button_pressed() -> void:
	print(%MusicEmitter)
	%MusicEmitter.set_parameter(&"Music States", int((%MusicEmitter.get_parameter(&"Music States")) + 1) % 4)
	
func _on_next_button_button_pressed() -> void:
	print(%MusicEmitter)
	%MusicEmitter.set_parameter(&"Music States", int((%MusicEmitter.get_parameter(&"Music States")) - 1) % 4)
