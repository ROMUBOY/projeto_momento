extends ColorRect
class_name lighting

func _ready() -> void:
	show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var light_positions = _get_light_positions()
	material.set_shader_parameter("number_of_lights", light_positions.size())
	material.set_shader_parameter("lights", light_positions)
	var lighting = PlayerStatus.lighting
	material.set_shader_parameter("range_of_light", lighting)
	material.set_shader_parameter("band_radius", lighting - 10)

func _get_light_positions():
	return get_tree().get_nodes_in_group("light").map(
		func(light: Node2D):
			return light.get_global_transform_with_canvas().origin
	)
