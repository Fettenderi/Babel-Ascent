class_name Weighter extends StaticBody3D

signal light_amount_changed

@export var _weight_indicator_mesh : TextMesh
@export var _light_scene : PackedScene

@onready var _lights : Array[XRToolsPickable]
@onready var _entities : Node

var _light_amount := 0:
	set(value):
		_light_amount = value
		_weight_indicator_mesh.text = str(value)
		light_amount_changed.emit(_light_amount)


func _ready() -> void:
	_entities = Node.new()
	
	_entities.name = "Entities"
	add_child(_entities, true)


func remove_light(amount: int) -> void:
	var _light : XRToolsPickable
	for _i in range(amount):
		_light = _lights.pop_back()
		_light.queue_free()

func add_light(amount: int) -> void:
	var _light_instance : XRToolsPickable
	for _i in range(amount):
		_light_instance = _light_scene.instantiate()
		
		_light_instance.global_position = global_position + Vector3(0.0, 0.8 + 0.2 * _i, 0.0)
		
		_entities.add_child(_light_instance, true)

func _on_light_detector_body_entered(body: Node3D) -> void:
	if body.is_in_group(&"Light"):
		_light_amount += 1
		_lights.append(body)

func _on_light_detector_body_exited(body: Node3D) -> void:
	if body.is_in_group(&"Light"):
		_light_amount -= 1
		_lights.erase(body)
