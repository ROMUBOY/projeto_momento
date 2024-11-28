extends Control

@onready var grid_container: GridContainer = $GridContainer
@export var item_collected :PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_itens()

func show_itens() -> void:
	print(PlayerStatus.get_itens_from_storage())
	for data in PlayerStatus.get_itens_from_storage():
		var temp = item_collected.instantiate()
		grid_container.add_child(temp)
		temp.setup(data)
