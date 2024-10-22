extends Node3D

@export_file('*.tscn') var fight_scene_name : String

func _ready() -> void:
	PlayerStats._current_health = PlayerStats.health

func _on_retry_button_button_pressed() -> void:
	get_parent().load_scene(fight_scene_name)

func _on_exit_button_button_pressed() -> void:
	get_tree().quit()
