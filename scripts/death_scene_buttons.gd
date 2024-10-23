extends Node3D

func _ready() -> void:
	PlayerStats._current_health = PlayerStats.health

func _on_retry_button_button_pressed() -> void:
	get_parent().load_scene(PhaseHandler.current_phase.current_scene_name)

func _on_exit_button_button_pressed() -> void:
	get_tree().quit()
