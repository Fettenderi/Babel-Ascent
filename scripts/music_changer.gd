extends Node

@export_range(0, 5, 1) var music_state : int

func _ready() -> void:
	FmodServer.set_global_parameter_by_name_with_label("music_states", str(music_state))
	
	queue_free()
