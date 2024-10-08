extends Node3D

func _on_previous_button_button_pressed() -> void:
	if %MusicEmitter.get_parameter(&"event_parameter/music_states/value") <= 0:
		%MusicEmitter.set_parameter(&"event_parameter/music_states/value", 3)
	else:
		%MusicEmitter.set_parameter(&"event_parameter/music_states/value", (%MusicEmitter.get_parameter(&"event_parameter/music_states/value") - 1) % 4)
	
	print(%MusicEmitter.get_parameter(&"event_parameter/music_states/value"))
	
func _on_next_button_button_pressed() -> void:
	%MusicEmitter.set_parameter(&"event_parameter/music_states/value", (%MusicEmitter.get_parameter(&"event_parameter/music_states/value") + 1) % 4)

	print(%MusicEmitter.get_parameter(&"event_parameter/music_states/value"))
