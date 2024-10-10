extends MeshInstance3D

const TRANSPARENT := Color(Color.WHITE, 0.0)

@onready var _material := get_surface_override_material(0)

func _ready() -> void:
	var _tween := create_tween()
	
	_tween.tween_property(_material, "color", Color.WHITE, 1).from(TRANSPARENT)
	_tween.tween_property(_material, "color", TRANSPARENT, 1).set_delay(5.0)
