extends Node2D

var tile_scene: PackedScene       = preload("res://Tile.tscn")
var empty_tile_scene: PackedScene = preload("res://EmptyTile.tscn")
var item_scene: PackedScene       = preload("res://Item.tscn")

@export var cols: int                     = 8
@export var rows: int                     = 5

@export var tile_size: int = 128

func set_tile(col: int, row: int):
	var tile: Tile = tile_scene.instantiate();
	tile.name = 'Tile'+ str(col) + ':' + str(row);
	tile.col = col
	tile.row = row
	tile.position = Vector2(10, 10)
	add_child(tile)

func set_item(col: int, row: int):
	var item: Item = item_scene.instantiate();
	item.name = 'Item'+ str(col) + ':' + str(row);
	item.col = col
	item.row = row
	item.tile_size = tile_size
	item.position = Vector2(tile_size * col, tile_size * row)
	add_child(item)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for row in rows:
		for col in cols:
			var emtpy_tile: EmptyTile = empty_tile_scene.instantiate()
			emtpy_tile.col = col
			emtpy_tile.row = row
			emtpy_tile.tile_size = tile_size
			add_child(emtpy_tile)
	set_item(0, 2) 


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	print("Inventory Variant" + str(at_position) + " " + str(data))
	return true
