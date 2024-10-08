extends XROrigin3D

@onready var camera : XRCamera3D = %XRCamera3D

func _on_hold_button_pressed() -> void:
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base: return
	
	scene_base.exit_to_main_menu()