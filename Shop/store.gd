extends Control

@onready var grid: GridContainer = $ScrollContainer/GridContainer

@export var store_item :PackedScene

@export var store_data : Array[Item]

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
	print(store_data[id].item_name + " bought")
