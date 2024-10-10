extends Node3D

@export var speed := 1.0

func _process(delta: float) -> void:
	position.y += delta * speed
