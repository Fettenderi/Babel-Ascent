@tool
class_name FightScene extends XRToolsSceneBase

@export var fight_resource : FightPhaseResource

var _current_wave := 0
var _current_enemy_count := 0:
	set(value):
		_current_enemy_count = value
		if _current_enemy_count <= 0:
			_current_wave += 1

func _ready() -> void:
	pass

func _spawn_enemy(enemy: EnemyResource) -> void:
	_current_enemy_count += 1

func _enemy_died():
	_current_enemy_count -= 1
