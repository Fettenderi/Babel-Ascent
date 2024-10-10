extends FmodEventEmitter3D

@onready var _parent : XRToolsSnapZone = get_parent()

func _ready() -> void:
	preload_event = true
	
	_parent.has_picked_up.connect(_play_event.unbind(1))

func _play_event():
	play()
