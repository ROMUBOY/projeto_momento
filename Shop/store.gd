extends Control

@onready var grid : GridContainer = %GridContainer

@export var store_item :PackedScene

@export var store_data : Array[Item]

enum type {INTEGRITY, STORAGE, FUEL, LIGHTING, MODULE_CAPACITY, PROPULSION_POWER, FILTER_EFFICIENCY, JUNK}

var store_item_id : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_store()

func setup_store() -> void:
	print("Conteúdo do array:", store_data)
	for data in store_data:
		var temp = store_item.instantiate()
		temp.item_buy_pressed.connect(on_item_buy_pressed)
		grid.add_child(temp)
		temp.setup(data, store_item_id)
		store_item_id +=1

func on_item_buy_pressed(id : int) -> void:
	var item = store_data[id]
	
	if(item.item_price > PlayerStatus.current_money):
		print("sem grana")
		return
	
	PlayerStatus.spend_money(item.item_price)
	
	match item.item_type:
		type.INTEGRITY:
			PlayerStatus.max_integrity += 10
		type.STORAGE:
			PlayerStatus.max_storage += 2
		type.FUEL:
			PlayerStatus.max_fuel += 10
		type.LIGHTING:
			PlayerStatus.lighting += 10
		type.PROPULSION_POWER:
			PlayerStatus.propulsion_power += 1
		type.FILTER_EFFICIENCY:
			PlayerStatus.filter_efficiency += 1
