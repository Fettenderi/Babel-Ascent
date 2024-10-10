@tool
extends Node3D

@export var note_speed := 5.0
@export var note_scene : PackedScene

@export var _sounds : Array[AudioStreamWAV]

@onready var _cords : Array[Node3D]
@onready var _notes : Node

@onready var _players : Array[AudioStreamPlayer3D]
@onready var _players_availability : Array[bool]

var _cords_count := 0
var _last_touched := -1
var _last_touched_positon : Vector3
var _streak := 0

func throw():
	var _note_instance := note_scene.instantiate()
	
	if _note_instance is Note:
		_note_instance.global_position = _last_touched_positon
		_note_instance.direction = - (_cords[0].global_position - _cords[1].global_position).normalized()
		_note_instance.speed = note_speed
		_note_instance.note_size_factor = 3.0
		_note_instance.despawn_time = 3.0
		_note_instance.set_note(Note.KEY_NOTE)
	
	_notes.add_child(_note_instance, true)


func play_note(note_position: Vector3, sprite_id: int, _sfx_id: int):
	if not is_inside_tree(): return
	
	var _note_instance := note_scene.instantiate()
	
	_notes.add_child(_note_instance, true)
	
	if _note_instance is Note:
		_note_instance.global_position = note_position
		_note_instance.set_note(sprite_id)

	var _player_id := 0
	while not _players_availability[_player_id]:
		_player_id += 1
		if _player_id >= _players_availability.size():
			_create_player(_player_id)
			break
	
	_players[_player_id].stream = _sounds[_sfx_id]
	_players[_player_id].play()
	_players_availability[_player_id] = false

func _player_freed(id: int):
	_players_availability[id] = true

func _ready() -> void:
	if Engine.is_editor_hint(): return
	
	for _child: HarpCord in get_children():
		_child.cord_touched.connect(_cord_touched.bind(_cords_count))
		_child.scale.y = 1.5 - 0.05 * _cords_count
		_child.scale.z = 1.5 - 0.05 * _cords_count
		_cords.append(_child)
		_cords_count += 1
	
	
	for _i in range(20):
		_create_player(_i)
	
	_notes = Node.new()
	_notes.name = "Notes"
	add_child(_notes, true)

func _create_player(id: int):
	var _player : AudioStreamPlayer3D
	_player = AudioStreamPlayer3D.new()
		
	_player.finished.connect(_player_freed.bind(id))
		
	add_child(_player, true)
		
	_players_availability.append(true)
	_players.append(_player)


func _cord_touched(pos: Vector3, _id: int) -> void:
	if _id <= _last_touched:
		_last_touched = _id
		_streak = 0
		play_note(pos, Note.FIRST_NOTE, _id)
		return
	
	_last_touched += 1
	_streak += 1
	
	@warning_ignore("integer_division")
	if _streak >= _cords_count * 0.7:
		_last_touched = -1
		_streak = 0
		_last_touched_positon = pos
		play_note(pos, Note.KEY_NOTE, _id)
		
		throw()
	else:
		play_note(pos, _streak, _id)
