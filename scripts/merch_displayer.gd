class_name MerchDisplayer extends Node3D

signal item_selected(id, is_main)
signal item_deselected(id, is_main)

@onready var _shop_resource : ShopPhaseResource:
	set(value):
		_shop_resource = value
		if _shop_resource:
			_update_merch()

@onready var _merch_slots : Array[XRToolsSnapZone] = []
@onready var _selected_merch_slots : Array[XRToolsSnapZone] = []

@onready var _selected_merch : Array[XRToolsPickable] = []

func _ready() -> void:
	_merch_slots.append_array(%Merch.get_children())
	_selected_merch_slots.append_array(%SelectedMerch.get_children())
	
	for _i in range(_selected_merch_slots.size()):
		_selected_merch_slots[_i].has_picked_up.connect(_has_selected_item.bind(_i))
		_selected_merch_slots[_i].has_dropped.connect(_has_deselected_item.bind(_i))
		_selected_merch.append(null)

func _update_merch():
	_put_merch(_merch_slots[0], _shop_resource.main_item1, true)
	_put_merch(_merch_slots[1], _shop_resource.main_item2, true)
	
	if _merch_slots.size() > 0:
		for _i in range(_merch_slots.size() - 2):
			_put_merch(_merch_slots[_i + 2], _shop_resource.secondary_items[_i])

func _put_merch(slot: XRToolsSnapZone, merch: ItemResource, is_main_item: bool = false) -> void:
	var merch_instance := merch.scene.instantiate()
	
	add_child(merch_instance, true)
	
	merch_instance.set_meta(&"IsMainItem", is_main_item)
	
	slot.pick_up_object(merch_instance)

func _has_selected_item(what: XRToolsPickable, slot_id: int) -> void:
	_selected_merch[slot_id] = what
	
	item_selected.emit(slot_id, what.get_meta(&"IsMainItem"))

func _has_deselected_item(slot_id: int) -> void:
	var what : XRToolsPickable = _selected_merch[slot_id]
	_selected_merch[slot_id] = null
	
	item_deselected.emit(slot_id, what.get_meta(&"IsMainItem"))
