extends Node

@onready var audio_players =$AudioStreamPlayers

const HURT_SOUND = preload("res://SoundPlayer/Sounds/qubodup-BangMid.ogg")
const DIED_SOUND = preload("res://SoundPlayer/Sounds/MachinePowerOff.ogg")
const INTERACTIBLE_SOUND = preload("res://SoundPlayer/Sounds/sharp_echo.wav")
const MENU_CONFIRM_SOUND = preload("res://SoundPlayer/Sounds/misc_menu.wav")
const MENU_UNCONFIRM_SOUND = preload("res://SoundPlayer/Sounds/misc_menu_3.wav")


func play_sound(sound):
	for audio_stream_player in audio_players.get_children():
		if not audio_stream_player.playing:
			audio_stream_player.stream = sound
			audio_stream_player.play()
			break
	
