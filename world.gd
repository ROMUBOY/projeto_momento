extends Node2D

const Player = preload("res://Player/player.tscn")
const Exit = preload("res://LevelExit/exit.tscn")
const Junk = preload("res://Junk/junk.tscn")

const Debris = [
	preload("res://Junk/Scenes/Debris/debris1.tscn"),
	preload("res://Junk/Scenes/Debris/debris2.tscn"),
	preload("res://Junk/Scenes/Debris/debris3.tscn")
]

const Relics = [
	preload("res://Junk/Scenes/Relics/relic1.tscn"),
	preload("res://Junk/Scenes/Relics/relic2.tscn"),
	preload("res://Junk/Scenes/Relics/relic3.tscn"),
	preload("res://Junk/Scenes/Relics/relic4.tscn"),
	preload("res://Junk/Scenes/Relics/relic5.tscn"),
	preload("res://Junk/Scenes/Relics/relic6.tscn"),
	preload("res://Junk/Scenes/Relics/relic7.tscn"),
]

const Artifacts = [
	preload("res://Junk/Scenes/Artifacts/artifact1.tscn")
]

const tileset_texture = [
	"res://Tilesets/monumento_tileset_prototype1.png",
	"res://Tilesets/monumento_tileset_prototype2.png",
	"res://Tilesets/monumento_tileset_prototype3.png",
	"res://Tilesets/monumento_tileset_prototype4.png"
]

const background_tileset_texture = [
	"res://Tilesets/background/monumento_tileset_prototypebg1.png",
	"res://Tilesets/background/monumento_tileset_prototypebg2.png",
	"res://Tilesets/background/monumento_tileset_prototypebg3.png",
	"res://Tilesets/background/monumento_tileset_prototypebg4.png"
]

var current_tileset_texture = 0

var borders = Rect2(1, 1, 28, 21)
var player_start_position : Vector2
var exit_position : Vector2

@onready var money_label: Label = %MoneyLabel
@onready var tile_map = $TileMap
@onready var background_tile_map: TileMap = $BackgroundTileMap
@onready var fake_tile_map: TileMap = $FakeTileMap
@onready var fake_background_tile_map: TileMap = $FakeBackgroundTileMap
@onready var menu_canvas_layer: CanvasLayer = $MenuCanvasLayer
@onready var health_bar: HBoxContainer = %HealthBar
@onready var health_bar_bar: Array[TextureRect]=[
	%HP1, %HP2, %HP3, %HP4, %HP5, %HP6, %HP7, %HP8
]
@onready var energy_bar: VBoxContainer = %EnergyBar
@onready var energy_bar_bar: Array[TextureRect]=[
	%Energy1, %Energy2, %Energy3, %Energy4, %Energy5, %Energy6, %Energy7, %Energy8
]

var current_collected_itens = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_level()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("change_filter"):
		#current_tileset_texture = (current_tileset_texture + 1)%4
		current_tileset_texture = (current_tileset_texture + 1)%2
		
		var texture = load(tileset_texture[current_tileset_texture])
		var background_texture = load(background_tileset_texture[current_tileset_texture])
		
		tile_map.tile_set.get_source(1).texture = texture
		background_tile_map.tile_set.get_source(0).texture = background_texture
		
		fake_tile_map.tile_set.get_source(0).texture = texture
		fake_background_tile_map.tile_set.get_source(0).texture = background_texture
		
		if current_tileset_texture == 1:
			fake_tile_map.hide()
			background_tile_map.show()
			fake_background_tile_map.hide()
		else:
			fake_tile_map.show()
			background_tile_map.hide()
			fake_background_tile_map.show()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(300)
	
	var player = Player.instantiate()
	add_child(player)
	player.position = map.front() * 32
	player_start_position = player.position
	player.connect("player_died", Callable(self, "reload_level"))
	
	var exit = Exit.instantiate()
	add_child(exit)
	#exit.position = walker.get_end_room().position * 32
	exit.position = walker.rooms[1].position * 32
	exit_position = exit.position
	exit.connect("leaving_level", Callable(self, "reload_level"))
	
	#walker.queue_free()
	var cells = []
	for location in map:
		cells.append(location)
	
	tile_map.set_cells_terrain_connect(0, cells, 0, -1)
	background_tile_map.set_cells_terrain_connect(0, cells, 0, 0)
	
	fake_tile_map.set_cells_terrain_connect(0, cells, 0, -1)
	fake_background_tile_map.set_cells_terrain_connect(0, cells, 0, 0)
	
	#walker.queue_free()	
	
	for room in walker.rooms:
		if randf() < 0.25 && room.position != map.front() && room.position != walker.rooms[1].position:
			
			var junk : Junk
			
			match randi_range(1, 10):
				1,2,3,4,5,6:
					junk = Debris[randi_range(0, Debris.size() - 1)].instantiate()
				7,8,9:
					junk = Relics[randi_range(0, Relics.size() - 1)].instantiate()
				10:
					junk = Artifacts[0].instantiate()
			
			add_child(junk)
			
			junk.position = room.position * 32
			
			if randf() < 0.75:
				cells = []
				
				for y in range(-room.size.y/2, room.size.y/2) :
					for x in range( -room.size.x/2, room.size.x/2):
						cells.append(Vector2(room.position.x + x, room.position.y + y))
				
				fake_tile_map.set_cells_terrain_connect(0, cells, 0, 0)
				fake_background_tile_map.set_cells_terrain_connect(0, cells, 0, -1)
		

func reload_level():
	var player = get_tree().get_root().get_node("World" +"/"+ "Player")
	PlayerStatus.current_integrity = player.get_current_health()
	
	current_collected_itens = player.get_collected_itens()
	
	player.queue_free()
	
	menu_canvas_layer.show()

func _on_new_area_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_revisit_area_button_pressed() -> void:
	var player = Player.instantiate()
	add_child(player)
	player.position = player_start_position
	menu_canvas_layer.hide()


func _on_store_load_scene_button_pressed() -> void:
	PlayerStatus.remove_all_itens_from_storage()
	
	for item in current_collected_itens:
		PlayerStatus.add_money(item.sell_price)
		var collected_item = {
			"texture" : item.texture,
			"sell_price" : item.sell_price
		}
		PlayerStatus.add_item_to_storage(collected_item)
