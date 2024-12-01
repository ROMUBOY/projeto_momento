extends Control

@onready var grid : GridContainer = %GridContainer

@onready var integrity_label: Label = %IntegrityLabel
@onready var storage_label: Label = %StorageLabel
@onready var battery_label: Label = %BatteryLabel
@onready var lighting_label: Label = %LightingLabel
@onready var acceleration_label: Label = %AccelerationLabel
@onready var filter_efficience_label: Label = %FilterEfficienceLabel

@onready var cash_label: Label = %CashLabel

@export var store_item :PackedScene

@export var store_data : Array[Item]

enum type {INTEGRITY, STORAGE, FUEL, LIGHTING, MODULE_CAPACITY, PROPULSION_POWER, FILTER_EFFICIENCY, JUNK}

var store_item_id : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_store()
	update_cash_label()
	update_ship_status()

func setup_store() -> void:
	
	for data in store_data:
		var temp = store_item.instantiate()
		temp.item_buy_pressed.connect(on_item_buy_pressed)
		grid.add_child(temp)
		temp.setup(data, store_item_id)
		store_item_id +=1

func on_item_buy_pressed(id : int) -> void:
	var item = store_data[id]
	
	if(item.item_price > PlayerStatus.current_money):
		SoundPlayer.play_sound(SoundPlayer.MENU_UNCONFIRM_SOUND)
		return
	
	PlayerStatus.spend_money(item.item_price)
	update_cash_label()
	
	match item.item_type:
		type.INTEGRITY:
			PlayerStatus.max_integrity += 10
		type.STORAGE:
			PlayerStatus.max_storage += 2
		type.FUEL:
			PlayerStatus.max_fuel += 10
		type.LIGHTING:
			PlayerStatus.lighting += 10
		type.PROPULSION_POWER:
			PlayerStatus.propulsion_power += 1
		type.FILTER_EFFICIENCY:
			PlayerStatus.filter_efficiency += 1
		
	SoundPlayer.play_sound(SoundPlayer.MENU_CONFIRM_SOUND)
	update_ship_status()

func update_cash_label():
	cash_label.text = "Cash: " + str(PlayerStatus.current_money)

func update_ship_status():
	integrity_label.text = "Integrity: " + str(PlayerStatus.max_integrity/10)
	storage_label.text = "Storage: " + str(PlayerStatus.max_storage)
	battery_label.text = "Battery: " + str(PlayerStatus.max_fuel/10)
	lighting_label.text = "Lighting: " + str(PlayerStatus.lighting/10)
	acceleration_label.text = "Acceleration: " + str(PlayerStatus.propulsion_power)
	filter_efficience_label.text = "Filter Efficience: " + str(PlayerStatus.filter_efficiency)
