extends Node2D
@onready var interaction_area: InteractionArea = $InteractionArea

signal leaving_level

func _ready() -> void:
	interaction_area.interact = Callable(self, "_exit")

func _exit():
	emit_signal("leaving_level")
