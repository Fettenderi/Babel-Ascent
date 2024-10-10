extends Node3D

const CLOUDS_SIZE := 153.385

@export var speed := 1.0

func _process(delta: float) -> void:
	position.z += delta * speed
	
	if position.z > CLOUDS_SIZE:
		position.z -= CLOUDS_SIZE
