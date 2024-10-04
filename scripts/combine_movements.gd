@tool
extends MovementBehaviour

func get_direction(time := -1.0) -> Vector3:
	var result := Vector3.ZERO
	
	for pattern in get_children():
		if pattern is MovementBehaviour:
			result += pattern.get_direction(time)
	
	return result
