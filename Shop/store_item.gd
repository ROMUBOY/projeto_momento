extends PanelContainer

signal item_buy_pressed(id)

@onready var texture: TextureRect = $HBoxContainer/MarginContainer/TextureRect

@onready var heading_1: Label = $HBoxContainer/MarginContainer2/VBoxContainer/Heading1
@onready var heading_2: Label = $HBoxContainer/MarginContainer2/VBoxContainer/Heading2

@onready var button: Button = $HBoxContainer/MarginContainer2/VBoxContainer/Button

var id : int


func setup(item : Item, p_id : int):
	#texture.texture = load(data.get("icon_path"))	
	heading_2.text = item.item_description
	heading_1.text = item.item_name
	id = p_id
	
	#if data.get("custom_button_text"):
		#button.text = data.get("custom_button_text")

func _on_button_pressed() -> void:
	emit_signal("item_buy_pressed", id)
