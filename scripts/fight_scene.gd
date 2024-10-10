@tool
class_name FightScene extends XRToolsSceneBase

@export_file('*.tscn') var death_scene : String

@onready var _fight_resource : FightPhaseResource
@onready var _wave_handler : WaveHandler = %WaveHandler
@onready var _xr_origin : XROrigin3D = $XROrigin3D

func _ready() -> void:
	_fight_resource = PhaseHandler.current_phase
	_wave_handler._fight_resource = _fight_resource
	
	PlayerStats.died.connect(_death_screen)

func _death_screen():
	load_scene(death_scene)
