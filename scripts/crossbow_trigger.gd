extends Node

@export var fire_force := 10.0

@export var ammo_slot : XRToolsSnapZone
@export var pull_trigger : XRToolsInteractableSlider

@onready var _parent : XRToolsPickable = get_parent()

var _has_arrow := false
var _arrow : ArrowPickable = null

func _ready() -> void:
	ammo_slot.has_picked_up.connect(_on_arrow_picked_up)
	pull_trigger.slider_moved.connect(_on_pull_trigger_moved)
	_parent.action_pressed.connect(_on_action_pressed_crossbow)

func _on_arrow_picked_up(what: Variant):
	_has_arrow = true
	_arrow = what
	ammo_slot.enabled = false

func _on_pull_trigger_moved(position: float) -> void:
	if position >= 0.05:
		_throw_arrow()

func _on_action_pressed_crossbow(_pickable: XRToolsPickable):
	_throw_arrow()


func _throw_arrow():
	if not _has_arrow: return
	
	ammo_slot.drop_object()
	
	_arrow.throw((%CrossbowEnd.global_position - %ArrowDirection.global_position).normalized() * fire_force, %CrossbowEnd.global_position)
	
	ammo_slot.enabled = true
	
	_arrow = null
	_has_arrow = false
