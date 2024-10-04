@tool
extends Node3D

@export var enabled := true

@export var enemies : Node3D
@export var player : Camera3D

@export var spawn_cooldown := 1.0

@export var enemy_scene : PackedScene

func _spawn_enemy():
	if enemy_scene and enabled:
		var enemy_instance : AbstractEnemy = enemy_scene.instantiate()
		
		enemies.add_child(enemy_instance, true)
		
		enemy_instance.global_position = global_position
		enemy_instance._player = player
		
		%SpawnCooldown.start(spawn_cooldown)

func _on_spawn_cooldown_timeout() -> void:
	_spawn_enemy()
