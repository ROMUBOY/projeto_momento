extends Sprite2D
class_name Junk

@onready var interaction_area: InteractionArea = $InteractionArea
@export var sell_price : int

@export var size = 2

func _ready() -> void:
	interaction_area.interact = Callable(self, "_collect")

func _collect():
	var player = get_tree().get_root().get_node("World" +"/"+ "Player")
	if player.add_item_to_collected_itens(self):
		hide()
		interaction_area.queue_free()
