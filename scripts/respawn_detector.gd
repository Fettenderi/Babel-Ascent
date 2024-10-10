extends Area3D

@export var respawn_if_touch : StringName

@onready var _parent : XRToolsPickable = get_parent()

@onready var _initial_position : Vector3 = _parent.global_position

func _respawn():
	_parent.global_position = _initial_position
	_parent.linear_velocity = Vector3.ZERO
	_parent.angular_velocity = Vector3.ZERO

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(respawn_if_touch):
		_respawn()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(respawn_if_touch):
		_respawn()
