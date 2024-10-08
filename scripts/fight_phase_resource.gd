class_name FightPhaseResource extends PhaseResource

@export var enemies : Array[EnemyResource]
@export_range(0.01, 1.0, 0.01) var spawn_probabilities : Array[float]

@export var next_shop : int
