@tool
extends MovementBehaviour

@export var axis : Vector3 = Vector3.ZERO:
	set(value):
		axis = value
		_setup_preview()

func get_direction(_time := -1.0) -> Vector3:
	return axis# * (1.0 if time < 0.0 else time)
