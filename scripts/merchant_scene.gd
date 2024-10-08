@tool
extends XRToolsSceneBase

@export var shop_resource : ShopPhaseResource

@onready var _merch_displayer := %MerchDisplayer

func _ready() -> void:
	_merch_displayer._shop_resource = shop_resource
