@tool
class_name MerchantScene extends XRToolsSceneBase

@onready var _shop_resource : ShopPhaseResource
@onready var _merch_displayer : MerchDisplayer = %MerchDisplayer

func _ready() -> void:
	_shop_resource = PhaseHandler.current_phase
	_merch_displayer._shop_resource = _shop_resource

func _on_merch_displayer_transaction_finished() -> void:
	load_scene(_shop_resource.next_scene_name)
	
	PhaseHandler.current_phase = _shop_resource.next_both_items
