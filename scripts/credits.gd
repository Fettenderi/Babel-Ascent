extends Node3D

@export var speed := 1.0

func _ready() -> void:
	PhaseHandler.current_phase.next_scene_name = "res://scenes/merchant_scene.tscn"

func _process(delta: float) -> void:
	position.y += delta * speed
