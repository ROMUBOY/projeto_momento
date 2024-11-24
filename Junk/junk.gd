extends Sprite2D
class_name Junk


@onready var interaction_area: InteractionArea = $InteractionArea
var size = 2

func _ready() -> void:
	interaction_area.interact = Callable(self, "_collect")

func _collect():
	var player = get_tree().get_root().get_node("World" +"/"+ "Player")
	if player.add_item_to_collected_itens(self):
		queue_free()
