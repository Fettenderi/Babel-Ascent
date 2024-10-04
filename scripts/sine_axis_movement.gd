@tool
extends MovementBehaviour

@export var axis := Vector3.ZERO:
	set(value):
		axis = value
		_setup_preview()

@export var amplitude := 1.0:
	set(value):
		amplitude = value
		_setup_preview()

@export var frequency := 1.0:
	set(value):
		frequency = value
		_setup_preview()

@export var offset := 0.0:
	set(value):
		offset = value
		_setup_preview()

var _elapsed := 0.0

func _physics_process(delta: float) -> void:
	_elapsed += delta

func get_direction(time := -1.0) -> Vector3:
	return axis * amplitude * sin(offset + frequency * (_elapsed if time < 0.0 else time))
