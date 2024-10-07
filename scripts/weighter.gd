extends StaticBody3D

signal light_amount_changed(value)

@export var _weight_indicator_mesh : TextMesh

@onready var _lights : Array[XRToolsPickable]

var _light_amount := 0:
	set(value):
		_light_amount = value
		_weight_indicator_mesh.text = str(value)
		light_amount_changed.emit(_light_amount)

func remove_light(amount: int) -> void:
	var _light : XRToolsPickable
	for _i in range(amount):
		_light = _lights.pop_back()
		_light.queue_free()

func _on_light_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"Light"):
		_light_amount += 1
		_lights.append(body)

func _on_light_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"Light"):
		_light_amount -= 1
		_lights.erase(body)
