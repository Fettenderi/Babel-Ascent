class_name MerchDisplayer extends Node3D

enum ItemType { MAIN_ITEM1, MAIN_ITEM2, SECONDARY_ITEM }

signal item_selected(item_resource : ItemResource, item_type : ItemType)
signal item_deselected(item_resource : ItemResource, item_type : ItemType)

signal transaction_finished(main1_picked : bool, main2_picked : bool)

@onready var _shop_resource : ShopPhaseResource:
	set(value):
		_shop_resource = value
		if _shop_resource and _transaction_ongoing:
			_update_merch()
			_update_prices()

@onready var _merch_slots : Array[MerchSlot] = []
@onready var _selected_merch_slots : Array[MerchSlot] = []

@onready var _selected_merch : Array[PickableItem] = []
@onready var _weighter : Weighter = %Weighter

var _items_picked := 0:
	set(value):
		if _items_picked + value == 1:
			_set_hand_enable(value > 0)
		_items_picked = value


var _transaction_ongoing := true

func _ready() -> void:
	for _child in %Merch.get_children():
		if _child is MerchSlot:
			_child.enabled = false
			_child.snap_require = _child.name
			_merch_slots.append(_child)
			
	
	for _child in %SelectedMerch.get_children():
		if _child is MerchSlot:
			_selected_merch_slots.append(_child)
	
	for _i in range(_selected_merch_slots.size()):
		_selected_merch_slots[_i].has_picked_up.connect(_has_selected_item.bind(_i))
		_selected_merch_slots[_i].has_dropped.connect(_has_deselected_item.bind(_i))
		_selected_merch.append(null)
	
	_weighter.add_light(PlayerStats._current_light)
	
	if _shop_resource and _transaction_ongoing:
		_update_merch()
		_update_prices()


func _complete_transaction() -> void:
	var _consumed_lights := 0
	var _main1_picked := false
	var _main2_picked := false
	_transaction_ongoing = false
	
	for _merch : PickableItem in _selected_merch:
		if _merch:
			_consumed_lights += _merch.item_resource.cost
			
			if PlayerStats.unlocked_items.has(_merch.item_resource.item_id):
				PlayerStats.unlocked_items[_merch.item_resource.item_id] = true
			elif _merch.item_resource.item_id == &"TowerUpgrade":
				PlayerStats.tower_level += 1
			
			match _merch.get_meta(&"ItemType"):
				ItemType.MAIN_ITEM1:
					_main1_picked = true
				ItemType.MAIN_ITEM2:
					_main2_picked = true
				ItemType.SECONDARY_ITEM:
					pass
	
	if not _main2_picked and _shop_resource.main_item2.item_id == &"TowerUpgrade":
		_main2_picked = PlayerStats.tower_level > 0
	
	if not _main1_picked and PlayerStats.unlocked_items.has(_shop_resource.main_item1.item_id):
		_main1_picked = PlayerStats.unlocked_items[_shop_resource.main_item1.item_id]
	if not _main2_picked and PlayerStats.unlocked_items.has(_shop_resource.main_item2.item_id):
		_main2_picked = PlayerStats.unlocked_items[_shop_resource.main_item2.item_id]
	
	
	
	PlayerStats._current_light -= _consumed_lights
	
	transaction_finished.emit(_main1_picked, _main2_picked)

func _set_hand_enable(value : bool) -> void:
	var _tween := create_tween()
	
	%Acceptance.enabled = value
	
	if value:
		_tween.tween_property(%MerchantHand, "position", Vector3(-0.16, 0.533, -0.42), 3)
	else:
		_tween.tween_property(%MerchantHand, "position", Vector3(-0.16, 0.533, -1.766), 3)
	

func _update_merch():
	if PlayerStats.unlocked_items.has(_shop_resource.main_item1.item_id):
		if not PlayerStats.unlocked_items[_shop_resource.main_item1.item_id]:
			_put_merch(_merch_slots[0], _shop_resource.main_item1, ItemType.MAIN_ITEM1)
	else:
		_put_merch(_merch_slots[0], _shop_resource.main_item1, ItemType.MAIN_ITEM1)
	
	if PlayerStats.unlocked_items.has(_shop_resource.main_item2.item_id):
		if not PlayerStats.unlocked_items[_shop_resource.main_item2.item_id]:
			_put_merch(_merch_slots[1], _shop_resource.main_item2, ItemType.MAIN_ITEM2)
	else:
		_put_merch(_merch_slots[1], _shop_resource.main_item2, ItemType.MAIN_ITEM2)
	
	if _merch_slots.size() > 0 and _shop_resource.secondary_items.size() == _merch_slots.size() - 2:
		for _i in range(_merch_slots.size() - 2):
			
			_put_merch(_merch_slots[_i + 2], _shop_resource.secondary_items[_i])

func _reposition_merch(merch: PickableItem) -> void:
	for _merch_slot in _merch_slots:
		if merch.is_in_group(_merch_slot.name):
			_put_merch(_merch_slot, merch.item_resource)
			merch.drop_and_free()
			return

func _update_prices():
	for _merch_slot : MerchSlot in _merch_slots:
		_merch_slot.set_enabled(_merch_slot.item_resource and _merch_slot.item_resource.cost <= _weighter._light_amount)

func _put_merch(slot: MerchSlot, merch: ItemResource, item_type: ItemType = ItemType.SECONDARY_ITEM) -> void:
	var merch_instance : PickableItem = merch.scene.instantiate()
	
	merch_instance.item_resource = merch
	merch_instance.add_to_group(slot.name)
	
	add_child(merch_instance, true)
	
	merch_instance.set_meta(&"ItemType", item_type)
	
	slot.pick_up_object(merch_instance)
	slot.item_resource = merch_instance.item_resource
	slot.change_price_tag(merch_instance.item_resource.cost)

func _has_selected_item(what: PickableItem, slot_id: int) -> void:
	_selected_merch[slot_id] = what
	
	_weighter.remove_light(what.item_resource.cost)
	
	_items_picked += 1
	#if  what.get_meta(&"ItemType") == ItemType.MAIN_ITEM1 or what.get_meta(&"ItemType") == ItemType.MAIN_ITEM2:
	
	item_selected.emit(what.item_resource, what.get_meta(&"ItemType"))


func _has_deselected_item(slot_id: int) -> void:
	var what : PickableItem = _selected_merch[slot_id]
	_selected_merch[slot_id] = null
	
	_weighter.add_light(what.item_resource.cost)
	
	_items_picked -= 1
	#if  what.get_meta(&"ItemType") == ItemType.MAIN_ITEM1 or what.get_meta(&"ItemType") == ItemType.MAIN_ITEM2:
	
	item_deselected.emit(what.item_resource, what.get_meta(&"ItemType"))
	
	_reposition_merch(what)


func _on_weighter_light_amount_changed(_value: Variant) -> void:
	_update_prices()


func _on_acceptance_has_dropped() -> void:
	_complete_transaction()
