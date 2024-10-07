extends Area3D

@export var respawn_if_touch : StringName

@onready var _parent : RigidBody3D = get_parent()

@onready var _initial_position : Vector3 = _parent.position

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(respawn_if_touch):
		_parent.position = _initial_position

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(respawn_if_touch):
		_parent.position = _initial_position
