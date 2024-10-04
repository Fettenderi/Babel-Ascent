extends Area3D

@export var despawn_if_touch : StringName

@onready var _parent : RigidBody3D = get_parent()

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group(despawn_if_touch):
		_parent.queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(despawn_if_touch):
		_parent.queue_free()
