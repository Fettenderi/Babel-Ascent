extends CharacterBody3D

@export var speed = 5.0

@export var movement_pattern : MovementBehaviour

func _physics_process(delta: float) -> void:
	if movement_pattern:
		velocity = (movement_pattern.get_direction() * transform.basis).normalized() * speed * delta

	move_and_slide()
