@tool
class_name XRToolsButtonPressed
extends Node3D

signal pressed

# Enable our button
@export var enabled : bool = false: set = set_enabled

@export var activate_action : String = "trigger_click"

# Countdown
@export var hold_time : float = 2.0

var time_held = 0.0

# Add support for is_xr_class on XRTools classes
func is_xr_class(name : String) -> bool:
	return name == "XRToolsButtonPressed"


# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		_set_time_held(0.0)

	_update_enabled()


func _process(delta):
	if Engine.is_editor_hint():
		return

	var button_pressed = false

	# we check all trackers
	var controllers = XRServer.get_trackers(XRServer.TRACKER_CONTROLLER)
	for name in controllers:
		var tracker : XRPositionalTracker = controllers[name]
		if tracker.get_input(activate_action):
			button_pressed = true

	if button_pressed:
		_set_time_held(time_held + delta)
		if time_held > hold_time:
			# done, disable this
			set_enabled(false)
			emit_signal("pressed")
	else:
		_set_time_held(max(0.0, time_held - delta))


func set_enabled(p_enabled: bool):
	enabled = p_enabled
	_update_enabled()


func _update_enabled():
	if is_inside_tree() and !Engine.is_editor_hint():
		_set_time_held(0.0)
		set_process(enabled)


func _set_time_held(p_time_held):
	time_held = p_time_held
