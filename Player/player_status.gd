extends Node

@export var max_integrity: int
@export var max_storage : int
@export var max_fuel: int
@export var lighting: float
@export var max_module_capacity: int
@export var propulsion_power: float
@export var filter_efficiency: float
var current_integrity: int

func _ready() -> void:
	current_integrity = max_integrity
