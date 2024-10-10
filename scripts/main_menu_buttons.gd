extends Node3D

@export_file('*.tscn') var first_scene_name : String
@export_file('*.tscn') var credits_scene_name : String

func _on_play_button_button_pressed() -> void:
	get_parent().load_scene(first_scene_name)


func _on_credits_button_button_pressed() -> void:
	get_parent().load_scene(credits_scene_name)


func _on_exit_button_button_pressed() -> void:
	get_tree().quit()
