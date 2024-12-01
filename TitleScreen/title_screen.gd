extends Control

@onready var main_menu: MarginContainer = $"PanelContainer/Main Menu"
@onready var settings: MarginContainer = $PanelContainer/Settings
@onready var credits: MarginContainer = $PanelContainer/Credits
@onready var how_to_play: MarginContainer = $"PanelContainer/How to Play"

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)

func change_from_main_menu(next_menu):
	main_menu.hide()
	next_menu.show()

func back_to_main_menu(previous_menu):
	main_menu.show()
	previous_menu.hide()

func _on_how_to_play_pressed() -> void:
	change_from_main_menu(how_to_play)

func _on_settings_pressed() -> void:
	change_from_main_menu(settings)


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	change_from_main_menu(credits)


func _on_settings_back_pressed() -> void:
	back_to_main_menu(settings)


func _on_credits_back_pressed() -> void:
	back_to_main_menu(credits)


func _on_how_to_play_back_pressed() -> void:
	back_to_main_menu(how_to_play)
