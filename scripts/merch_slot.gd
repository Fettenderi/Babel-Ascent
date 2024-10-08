@tool
class_name MerchSlot extends XRToolsSnapZone

@onready var item_resource : ItemResource
@onready var _price_tag_mesh : TextMesh

func change_price_tag(value : int) -> void:
	_price_tag_mesh.text = str(value)

func set_enabled(value: bool) -> void:
	%CrossMesh.set_deferred("visible", not value)
	enabled = value

func _ready() -> void:
	_price_tag_mesh = TextMesh.new()
	_price_tag_mesh.text = "/"
	_price_tag_mesh.depth = 0.01
	%PriceTag.mesh = _price_tag_mesh
