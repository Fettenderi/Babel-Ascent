extends Node

@export var ammo_slot : XRToolsSnapZone
@export var pull_trigger : XRToolsInteractableSlider

#@onready var _parent : XRToolsPickable = get_parent()

var _has_arrow := false
var _arrow : XRToolsPickable = null

func _ready() -> void:
	ammo_slot.has_picked_up.connect(_on_arrow_picked_up)
	pull_trigger.slider_moved.connect(_on_pull_trigger_moved)
	#_parent.action_pressed.connect(_on_action_pressed_crossbow)

func _on_arrow_picked_up(what: Variant):
	_has_arrow = true
	_arrow = what

func _on_pull_trigger_moved(position: Vector3) -> void:
	print(position)

func _on_action_pressed_crossbow(_pickable: XRToolsPickable):
	if not _has_arrow: return
	
	ammo_slot.drop_object()
	
	_arrow.throw(10.0)
