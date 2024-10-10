extends Node

@export var duration := 1.0

@onready var _parent : AbstractEnemy = get_parent()

@onready var _effect_removal_timer : Timer

var _previous_speed := 0.0

func _ready() -> void:
	_previous_speed = _parent.speed
	_parent.speed = 0.01
	
	_effect_removal_timer = Timer.new()
	_effect_removal_timer.autostart = true
	_effect_removal_timer.one_shot = true
	_effect_removal_timer.wait_time = duration
	_effect_removal_timer.timeout.connect(queue_free)
	
	add_child(_effect_removal_timer, true)

func _exit_tree() -> void:
	_parent.speed = _previous_speed
