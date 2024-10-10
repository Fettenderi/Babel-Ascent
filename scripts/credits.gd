extends Node3D

@export var speed := 1.0

func _ready() -> void:
	FmodServer.set_global_parameter_by_name_with_label("music_states", "1")


func _process(delta: float) -> void:
	position.y += delta * speed
