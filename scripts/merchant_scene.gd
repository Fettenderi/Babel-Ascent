@tool
class_name MerchantScene extends XRToolsSceneBase

enum PickedMainItems { MAIN_ITEM1, MAIN_ITEM2, BOTH, NONE }

@onready var _shop_resource : ShopPhaseResource
@onready var _merch_displayer : MerchDisplayer = %MerchDisplayer

func _ready() -> void:
	_shop_resource = PhaseHandler.current_phase
	_merch_displayer._shop_resource = _shop_resource

func _on_merch_displayer_transaction_finished(main1_picked: bool, main2_picked: bool) -> void:
	load_scene(_shop_resource.next_scene_name)
	
	if main1_picked:
		if main2_picked:
			PhaseHandler.current_phase = _shop_resource.next_both_items
		else:
			PhaseHandler.current_phase = _shop_resource.next_only_item1
	else:
		PhaseHandler.current_phase = _shop_resource.next_only_item2
