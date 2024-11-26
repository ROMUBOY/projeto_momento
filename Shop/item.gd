extends Node
class_name Item

enum type {INTEGRITY, STORAGE, FUEL, LIGHTING, MODULE_CAPACITY, PROPULSION_POWER, FILTER_EFFICIENCY, JUNK}

@export var item_name : String
@export var item_description : String
@export var item_price : int
@export var item_type : type
@export var item_power : int

#func _init(name : String, description: String, price : int, power : int) -> void:
	#item_name = name
	#item_description = description
	#item_price = price
	#item_power = power
