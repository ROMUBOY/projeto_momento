extends Sprite2D
@onready var interaction_area: InteractionArea = $InteractionArea

func _ready() -> void:
	interaction_area.interact = Callable(self, "_collect")

func _collect():
	queue_free()
