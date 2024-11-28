extends Panel

@onready var texture_rect: TextureRect = $HBoxContainer/TextureRect
@onready var cash_label: Label = $HBoxContainer/CashLabel

func setup(item):
	cash_label.text = "+ $" + str(item["sell_price"])
	texture_rect.texture = item["texture"]
