@tool
class_name FightScene extends XRToolsSceneBase

@export_file('*.tscn') var death_scene : String
@export var shops : ShopsResource

@onready var _fight_resource : FightPhaseResource
@onready var _wave_handler : WaveHandler = %WaveHandler
@onready var _xr_origin : XROrigin3D = $XROrigin3D

func _ready() -> void:
	_fight_resource = PhaseHandler.current_phase
	_wave_handler._fight_resource = _fight_resource
	
	PlayerStats.died.connect(_death_screen)

func _death_screen():
	load_scene(death_scene)

func _on_wave_handler_waves_ended() -> void:
	load_scene(_fight_resource.next_scene_name)
	
	PhaseHandler.current_phase = shops.shops[_fight_resource.next_shop]
