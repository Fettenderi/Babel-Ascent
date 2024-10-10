@tool
class_name Light extends XRToolsPickable

@export var despawning_time := 2.0
@onready var _despawning_timer : Timer

var needs_despawning := false

func _ready() -> void:
	super()
	
	if not needs_despawning: return
	
	enabled = false
	freeze = true
	
	_despawning_timer = Timer.new()
	_despawning_timer.autostart = true
	_despawning_timer.one_shot = true
	_despawning_timer.wait_time = despawning_time
	_despawning_timer.timeout.connect(_start_despawn)
	
	add_child(_despawning_timer, true)
	
	PlayerStats._current_light += 1


func _start_despawn():
	var _tween := create_tween()
	
	_tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0) * 1.5, 0.5)
	
	_tween.tween_property(self, "scale", Vector3(1.0, 1.0, 1.0) * 0.2, 0.3).set_delay(0.7)
	
	await get_tree().create_timer(1.5).timeout
	
	queue_free()
