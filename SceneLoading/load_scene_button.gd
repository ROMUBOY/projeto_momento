extends Button

@export_file("*.tscn") var target_level_path = ""

func _on_pressed() -> void:
	get_tree().change_scene_to_file(target_level_path)
