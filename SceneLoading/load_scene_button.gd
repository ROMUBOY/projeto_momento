extends Button

@export_file("*.tscn") var target_level_path = ""

enum type {CONFIRM, CANCEL}

@export var button_type = type.CONFIRM

func _on_pressed() -> void:
	play_type_button_sound()
	
	get_tree().change_scene_to_file(target_level_path)

func play_type_button_sound():
	if button_type == type.CONFIRM:
		SoundPlayer.play_sound(SoundPlayer.MENU_CONFIRM_SOUND) 
	else:
		SoundPlayer.play_sound(SoundPlayer.MENU_UNCONFIRM_SOUND)
