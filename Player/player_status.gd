extends Node

@export var max_integrity: int
@export var max_storage : int
@export var max_fuel: int
@export var lighting: float
@export var max_module_capacity: int
@export var propulsion_power: float
@export var filter_efficiency: float

var storage : Array
var current_integrity: int
var current_money: int = 10

func _ready() -> void:
	restart()

func restart():
	current_integrity = max_integrity
	storage = []

func add_item_to_storage(item):
	storage.append(item)

func remove_item_from_storage(item):
	var index = storage.find(item)
	storage.remove_at(index)

func remove_all_itens_from_storage():
	storage = []

func get_itens_from_storage():
	return storage

func add_money(amount : int):
	current_money += amount

func spend_money(amount : int):
	current_money -= amount

func get_current_money():
	return current_money
