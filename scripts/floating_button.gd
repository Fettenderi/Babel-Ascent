@tool
extends Node3D

signal button_pressed

@export var text := "":
	set(value):
		text = value
		if Engine.is_editor_hint():
			_update_shapes()

@onready var _text_mesh : TextMesh = $Text.mesh
@onready var _button_mesh : MeshInstance3D = $Text/Button
@onready var _collision_shape : BoxShape3D = $InteractableAreaButton/CollisionShape3D.shape

func _ready() -> void:
	_update_shapes()

func _update_shapes():
	var _lenght := text.length()
	
	_text_mesh.set_deferred("text", text)
	_button_mesh.set_deferred("scale", Vector3(0.326 + 0.034 * _lenght, _button_mesh.scale.y, _button_mesh.scale.z))
	_collision_shape.set_deferred("size", Vector3(0.22 + 0.10 * _lenght, _collision_shape.size.y, _collision_shape.size.z))

func _on_interactable_area_button_button_released(_button: Variant) -> void:
	button_pressed.emit()
