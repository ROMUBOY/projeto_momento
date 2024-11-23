extends Sprite2D
@onready var interaction_area: InteractionArea = $InteractionArea
var size = 2

func _ready() -> void:
	interaction_area.interact = Callable(self, "_collect")

func _collect():
	queue_free()
