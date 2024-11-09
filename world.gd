extends Node2D

const Player = preload("res://player.tscn")
const Exit = preload("res://exit.tscn")
const Junk = preload("res://junk.tscn")

var borders = Rect2(1, 1, 28, 21)

@onready var tile_map = $TileMap

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(19, 11), borders)
	var map = walker.walk(500)
	
	var player = Player.instantiate()
	add_child(player)
	player.position = map.front() * 32
	
	var exit = Exit.instantiate()
	add_child(exit)
	#exit.position = walker.get_end_room().position * 32
	exit.position = map.front() * 25
	exit.connect("leaving_level", Callable(self, "reload_level"))
	
	walker.queue_free()
	var cells = []
	for location in map:
		cells.append(location)
	tile_map.set_cells_terrain_connect(0, cells, 0, -1)
	
	for room in walker.rooms:
		if randf() < 0.10:
			var junk = Junk.instantiate()
			add_child(junk)
			junk.position = room.position * 32

func reload_level():
	get_tree().reload_current_scene()
