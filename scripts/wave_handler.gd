class_name WaveHandler extends Node3D

signal waves_ended

@onready var _fight_resource : FightPhaseResource:
	set(value):
		_fight_resource = value
		_spawn_wave()

@onready var _player : XRCamera3D
@onready var _enemies : Node
@onready var _spawning_delay : Timer

var _current_wave := 0:
	set(value):
		_current_wave = value
		_spawn_wave()

var _current_enemy_count := 0:
	set(value):
		_current_enemy_count = value
		if _current_enemy_count <= 0:
			_current_wave += 1

var _enemy_offset := 0

func _ready() -> void:
	randomize()
	
	_player = XRTools.find_xr_child(get_parent(), "*", "XRCamera3D", true)
	
	_enemies = Node.new()
	_enemies.name = "Enemies"
	add_child(_enemies, true)
	
	_spawning_delay = Timer.new()
	_spawning_delay.autostart = false
	_spawning_delay.one_shot = true
	add_child(_spawning_delay, true)

func _spawn_wave():
	if not _fight_resource: return
	
	if _fight_resource.enemy_waves.size() == _current_wave + 1:
		waves_ended.emit()
	
	for _i in range(_fight_resource.enemy_waves[_current_wave]):
		if _fight_resource.spawn_probabilities[_i + _enemy_offset] == 1.0 or randf() <= _fight_resource.spawn_probabilities[_i + _enemy_offset]:
			_spawn_enemy(_fight_resource.enemies[_i + _enemy_offset])
	
	_enemy_offset += _fight_resource.enemy_waves[_current_wave]

func _spawn_enemy(enemy: EnemyResource) -> void:
	var _enemy_scene : PackedScene = enemy.variants.pick_random()
	var _enemy_instance : AbstractEnemy = _enemy_scene.instantiate()
	
	_enemy_instance.global_position = _get_spawn_location()
	_enemy_instance.died.connect(_enemy_died)
	_enemy_instance._player = _player
	
	_enemies.add_child(_enemy_instance, true)
	
	_current_enemy_count += 1
	
	_spawning_delay.start(randf() * 5)
	
	await _spawning_delay.timeout

func _get_spawn_location() -> Vector3:
	var _spawn_location := -_player.basis.z
	_spawn_location.y = (randf() * 2 - 1) * 0.3 + 0.1
	_spawn_location += _player.basis.x * (randf() * 2 - 1) * 0.6
	
	_spawn_location = _spawn_location.normalized()
	
	_spawn_location *= 25
	_spawn_location.y += _player.global_position.y
	
	return _spawn_location

func _enemy_died():
	_current_enemy_count -= 1

func _on_tower_builder_tower_built() -> void:
	_spawn_wave()
