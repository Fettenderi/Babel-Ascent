extends Node3D

func _on_previous_button_button_pressed() -> void:
	if int(FmodServer.get_global_parameter_by_name(&"music_states")) <= 0:
		FmodServer.set_global_parameter_by_name_with_label(&"music_states", "3")
	else:
		FmodServer.set_global_parameter_by_name_with_label(&"music_states", str(int(FmodServer.get_global_parameter_by_name(&"music_states")) - 1) % 4)
	
	print(FmodServer.get_global_parameter_by_name(&"music_states"))
	
func _on_next_button_button_pressed() -> void:
	FmodServer.set_global_parameter_by_name_with_label(&"music_states", str(int(FmodServer.get_global_parameter_by_name(&"music_states")) + 1) % 4)

	print(FmodServer.get_global_parameter_by_name(&"music_states"))
