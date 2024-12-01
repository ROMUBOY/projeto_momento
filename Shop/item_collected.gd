extends Panel

@onready var texture_rect: TextureRect = $MarginContainer/HBoxContainer/TextureRect
@onready var cash_label: Label = $MarginContainer/HBoxContainer/CashLabel

func setup(item):
	cash_label.text = "+ $" + str(item["sell_price"])
	texture_rect.texture = item["texture"]
