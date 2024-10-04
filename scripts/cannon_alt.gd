extends Node3D

@export var fire_force := 100.0
@export var cooldown_time := 0.5
@export var delay_time := 1.5

@export var cannon_ball_scene : PackedScene

@onready var _cooldown_timer : Timer
@onready var _delay_timer : Timer
@onready var _entities : Node
@onready var _ammos : Array[XRToolsSnapZone] = []

var _on_cooldown := false
var _is_buffered := true

func _ready() -> void:
	_cooldown_timer = Timer.new()
	_cooldown_timer.name = "CooldownTimer"
	_cooldown_timer.autostart = false
	_cooldown_timer.one_shot = true
	_cooldown_timer.wait_time = cooldown_time
	_cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)
	call_deferred("add_child", _cooldown_timer, true)

	_delay_timer = Timer.new()
	_delay_timer.name = "DelayTimer"
	_delay_timer.autostart = false
	_delay_timer.one_shot = true
	_delay_timer.wait_time = delay_time
	_delay_timer.timeout.connect(_on_delay_timer_timeout)
	call_deferred("add_child", _delay_timer, true)
	
	_entities = Node.new()
	_entities.name = "Entities"
	call_deferred("add_child", _entities, true)
	
	_ammos.append_array(%Ammos.get_children())

func _fire_cannon():
	var _cannon_ball_instance : CannonBallPickable = cannon_ball_scene.instantiate()
	
	_entities.add_child(_cannon_ball_instance, true)
	
	_cannon_ball_instance.throw((%FireHole.global_position - %BallDirection.global_position).normalized() * fire_force, %FireHole.global_position)

func _has_ammo() -> bool:
	for _ammo: XRToolsSnapZone in _ammos:
		if is_instance_valid(_ammo.picked_up_object):
			return true
	return false

func _remove_ammo():
	var _cannon_ball : XRToolsPickable
	
	for _ammo: XRToolsSnapZone in _ammos:
		_cannon_ball = _ammo.picked_up_object
		if is_instance_valid(_cannon_ball):
			_ammo.drop_object()
			_cannon_ball.queue_free()
			return

func _on_large_button_button_pressed() -> void:
	if not _has_ammo(): return
	
	if _on_cooldown:
		_is_buffered = true
		return
	
	_on_cooldown = true
	
	_cooldown_timer.start()


func _on_cooldown_timer_timeout():
	_remove_ammo()
	_fire_cannon()
	if _is_buffered:
		_on_cooldown = false
		_is_buffered = false
		_on_large_button_button_pressed()
	else:
		_delay_timer.start()
	
func _on_delay_timer_timeout():
	_on_cooldown = false
