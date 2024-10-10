class_name WaveHandler extends Node3D

@onready var _fight_resource : FightPhaseResource:
	set(value):
		_fight_resource = value
		
		_update_waves()

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
	FmodServer.set_global_parameter_by_name_with_label("music_states", "2")
	
	_player = XRTools.find_xr_child(get_parent(), "*", "XRPlayer", true)
	
	_enemies = Node.new()
	_enemies.name = "Enemies"
	add_child(_enemies, true)
	
	_spawning_delay = Timer.new()
	_spawning_delay.autostart = false
	_spawning_delay.one_shot = true
	add_child(_spawning_delay, true)
	
	_update_waves()

func _update_waves():
	_enemy_offset = 0
	_current_enemy_count = 0
	_current_wave = 0

func _spawn_wave():
	if not _fight_resource: return
	
	for _i in range(_fight_resource.enemy_waves[_current_wave]):
		_spawn_enemy(_fight_resource.enemies[_i + _enemy_offset])
	
	_enemy_offset += _fight_resource.enemy_waves[_current_wave]

func _spawn_enemy(enemy: EnemyResource) -> void:
	var _enemy_scene : PackedScene = enemy.variants.pick_random()
	var _enemy_instance : AbstractEnemy = _enemy_scene.instantiate()
	
	_enemy_instance.global_position = _get_spawn_location()
	
	_enemies.add_child(_enemy_instance, true)
	
	_current_enemy_count += 1
	
	_spawning_delay.start(randf() * 5)
	await _spawning_delay.timeout
	
	_enemy_instance.died.connect(_enemy_died)

func _get_spawn_location() -> Vector3:
	var _player_direction := _player.basis.z
	_player_direction.y = 0
	
	
	return Vector3.ZERO

func _enemy_died():
	_current_enemy_count -= 1
