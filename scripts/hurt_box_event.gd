extends FmodEventEmitter3D

@onready var _parent : HurtBox = get_parent()

func _ready() -> void:
	preload_event = true
	
	_parent.hurtbox_entered.connect(_play_event.unbind(1))

func _play_event():
	play()
