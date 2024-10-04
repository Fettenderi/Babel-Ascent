@tool
extends MovementBehaviour

@export var axis : Vector3 = Vector3.ZERO:
	set(value):
		axis = value
		_setup_preview()

@export var noise_influence := 1.0:
	set(value):
		noise_influence = value
		_setup_preview()

var _elapsed := 0.0

func _physics_process(delta: float) -> void:
	_elapsed += delta

func get_direction(time := -1.0) -> Vector3:
	return axis * Vector3(_get_noise(time), _get_noise(time + 1.0), _get_noise(time + 2.0))

func _get_noise(time: float) -> float:
	seed((_elapsed if time < 0.0 else time) * 100)
	return (randf() * 2 - 1) * noise_influence
