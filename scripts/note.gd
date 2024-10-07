class_name Note extends AnimatedSprite3D

const KEY_NOTE := 0
const FIRST_NOTE := 1

const NOTE_SIZE := 0.0003

@export var speed := 0.5
@export var despawn_time := 0.7
@export var direction := Vector3.UP
@export var note_size_factor := 1.0

@onready var _despawn_timer : Timer

func set_note(id: int) -> void:
	frame = id

func _ready() -> void:
	_despawn_timer = Timer.new()
	
	_despawn_timer.autostart = true
	_despawn_timer.one_shot = true
	_despawn_timer.wait_time = despawn_time
	_despawn_timer.timeout.connect(_on_despawn_timeout)
	
	add_child(_despawn_timer, true)
	
	randomize()
	pixel_size = NOTE_SIZE * (randf() * 0.5 + 1) * note_size_factor
	position.x += (randf() * 2.0 - 1) * 0.05
	position.y += (randf() * 2.0 - 1) * 0.05
	position.z += (randf() * 2.0 - 1) * 0.05

func _process(delta: float) -> void:
	position += direction * speed * delta

func _on_despawn_timeout():
	queue_free()
